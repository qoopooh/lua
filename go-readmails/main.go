package main

import (
	"crypto/tls"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/emersion/go-imap"
	"github.com/emersion/go-imap/client"
	"github.com/emersion/go-message"
)

func main() {
	// Connect to the server
	tlsConfig := &tls.Config{InsecureSkipVerify: true}
	c, err := client.DialTLS("sdbemail01.simdif.local:993", tlsConfig)
	if err != nil {
		log.Fatal(err)
	}
	defer c.Logout()

	// Login
	username := os.Getenv("BUG_REPORT_EMAIL")
	password := os.Getenv("BUG_REPORT_PASSWORD")
	if err := c.Login(username, password); err != nil {
		log.Fatal(err)
	}

	// Select INBOX
	mbox, err := c.Select("INBOX.omise", false)
	if err != nil {
		log.Fatal(err)
	}

	// Get the last 10 messages
	from := mbox.Messages - 2
	to := mbox.Messages
	seqset := new(imap.SeqSet)
	seqset.AddRange(from, to)

	// Fetch the messages
	messages := make(chan *imap.Message, 3)
	go func() {
		if err := c.Fetch(seqset, []imap.FetchItem{imap.FetchEnvelope, imap.FetchItem("BODY.PEEK[]")}, messages); err != nil {
			log.Fatal(err)
		}
	}()

	for msg := range messages {
		if !strings.Contains(msg.Envelope.Subject, "URI") {
			continue
		}
		out := "* " + msg.Envelope.Subject

		for _, literal := range msg.Body {

			m, err := message.Read(literal)
			if message.IsUnknownCharset(err) {
				// This error is not fatal
				log.Println("Unknown encoding:", err)
			} else if err != nil {
				log.Fatal(err)
			}

			if mr := m.MultipartReader(); mr != nil {
				// // This is a multipart message
				// log.Println("This is a multipart message containing:")
				for {
					p, err := mr.NextPart()
					if err == io.EOF {
						break
					} else if err != nil {
						log.Fatal(err)
					}

					t, _, _ := p.Header.ContentType()
					// log.Println("A part with type", t)

					if t == "text/plain" {
						if body, err := io.ReadAll(p.Body); err == nil {
							// fmt.Println(string(body))
							url := string(body)
							out += "\n" + url + "\n" + redirect(url)
						}
					}
				}
			} else {
				t, _, _ := m.Header.ContentType()
				log.Println("This is a non-multipart message with type", t)

				// if body, err := io.ReadAll(m.Body); err == nil {
				// 	fmt.Println(string(body))
				// }
			}
		}

		fmt.Println(out)
	}
}

func redirect(url string) string {

	url = strings.TrimSpace(url)

	client := &http.Client{
		CheckRedirect: func(req *http.Request, via []*http.Request) error {
			// Return http.ErrUseLastResponse to prevent automatic redirection
			return http.ErrUseLastResponse
		},
	}

	// Make a GET request
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		log.Println("Error creating request:", err)
		return ""
	}

	// Perform the request
	resp, err := client.Do(req)
	if err != nil {
		log.Println("Error performing request:", err)
		return ""
	}
	defer resp.Body.Close()

	// Check if it's a redirect (status code 302)
	if resp.StatusCode == http.StatusFound {
		// Get the redirected URL
		redirectURL, err := resp.Location()
		if err != nil {
			log.Println("Error getting redirect URL:", err)
			return ""
		}
		// log.Println("Redirect URL:", redirectURL)
		return redirectURL.String()
	} else {
		if body, err := io.ReadAll(resp.Body); err == nil {
			log.Println("Response body", len(body))
		} else {
			log.Println("Request was not redirected.", resp.StatusCode)
		}

		for key, values := range resp.Header {
			for _, value := range values {
				log.Printf("%s: %s\n", key, value)
			}
		}
	}

	return ""
}


package notification

import (
    "fmt"
    apns "github.com/sideshow/apns2"
    payload "github.com/sideshow/apns2/payload"
    "github.com/sideshow/apns2/certificate"
    "os"
)

/*
* Sends a push notification of a suspected overdose to the specified
* device with the passed latitude, longitude, and additional notes
* 
* @param deviceToken is the device you are sending a notification to
* @param details is a map of the latitude, longitude, and notes about the incident
* @param development is whether you are testing the notifications in dev mode
* @returns true if sending the notification was successful
*/
func SendNotification(deviceToken string, details map[string]string, development bool) bool{
    fmt.Println("Sending notification")

    // Decrypt push notification certificate
    cert, pemErr := certificate.FromP12File("./pushcert.p12", os.Getenv("NALOXONE_APP_KEY"))

    if pemErr != nil{
        fmt.Println("Cert Error: ", pemErr)
        return false
    }

    notification := &apns.Notification{}
    notification.DeviceToken = deviceToken

    payload := payload.NewPayload()
    payload.Alert("Suspected Opioid Overdose").Badge(1).Custom("details", details).Sound("alarm.caf")
    notification.Payload = payload
    notification.Topic = "com.asynchronous.naloxone"

    notification.DeviceToken = deviceToken
    client := apns.NewClient(cert).Production()

    // When in development mode, use personal device token  
    if development == true{
        client = apns.NewClient(cert).Development()
    }

    _, err := client.Push(notification)

    if err != nil{
        fmt.Println("Failure to send push notification: ", err)
        return false
    }

    return true
}
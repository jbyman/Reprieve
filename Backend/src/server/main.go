/* HTTP web server for handling requests
* Request comes in as: http://localhost:8000/?request_name=update_provider_location&provider_id=2&......
*/

package main

import (
    "net/http"
    "fmt"
    "handler"
    "dispatch"
    "strconv"
    "io"
    "encoding/json"
)

/*
* First function called when HTTP request comes in.
* Should take in the string address of the suspected opioid overdose,
* which will be geocoded and then sent to the providers.
*
*/
func handleRequest(writer http.ResponseWriter, request *http.Request){
    fmt.Println("Request handled!")
    request_name := request.FormValue("request_name")

    switch(request_name){

        /*
        * Request is to update the provider's location
        */
        case "update_provider_location":
            fmt.Println("Update Provider Location")

            provider, err := strconv.Atoi(request.FormValue("provider_id"))

            if err != nil{
                panic(err.Error())
            }

            latitude, err := strconv.ParseFloat(request.FormValue("provider_lat"), 64)

            if err != nil{
                panic(err.Error())
            }

            longitude, err := strconv.ParseFloat(request.FormValue("provider_long"), 64)

            if err != nil{
                panic(err.Error())
            }

            handler.UpdateProviderLocation(provider, latitude, longitude)

        /*
        * Request is a new incident has come in from dispatch
        */
        case "new_incident":
            fmt.Println("New Incident Request")
            latitude, err := strconv.ParseFloat(request.FormValue("incident_lat"), 64)

            if err != nil{
                panic(err.Error())
            }

            longitude, err := strconv.ParseFloat(request.FormValue("incident_long"), 64)

            if err != nil{
                panic(err.Error())
            }

            dispatcher, err := strconv.Atoi(request.FormValue("dispatcher_id"))

            if err != nil{
                panic(err.Error())
            }
            

            notes := request.FormValue("notes")

            // Create a new incident and dispatch it
            new_incident := strconv.Itoa(handler.NewIncident(dispatcher, longitude, latitude, notes))
            dispatch.Dispatch(new_incident)

        /*
        * Request is a new provider
        */
        case "new_provider":
            fmt.Println("New Provider Request")

            first_name := request.FormValue("first_name")
            last_name := request.FormValue("last_name")
            phone_number := request.FormValue("phone_number")

            latitude, err := strconv.ParseFloat(request.FormValue("provider_lat"), 64)

            if err != nil{
                panic(err.Error())
            }

            longitude, err := strconv.ParseFloat(request.FormValue("provider_long"), 64)

            if err != nil{
                panic(err.Error())
            }

            device_token := request.FormValue("device_token")

            if err != nil{
                panic(err.Error())
            }

            provider := strconv.Itoa(handler.AddProvider(first_name, last_name, phone_number, latitude, longitude, device_token))

            io.WriteString(writer, provider)



        /*
        * Provider accepts incident dispatch
        */
        case "provider_accepts":
            fmt.Println("Provider Accepts Request")

            device_token := request.FormValue("device_token")

            incident_id, err := strconv.Atoi(request.FormValue("incident_id"))

            if err != nil{
                panic(err.Error())
            }

            handler.ProviderAcceptsRequest(device_token, incident_id)

        /*
        * End a current incident
        */
        case "end_incident":
            fmt.Println("Ending incident")

            incident_id, err := strconv.Atoi(request.FormValue("incident_id"))

            if err != nil{
                panic(err.Error())
            }

            handler.EndOrCancelIncident(incident_id)


        /*
        * Provider unregisters as a provider
        */
        case "unregister":
            fmt.Println("Unregistering provider")

            device_token := request.FormValue("device_token")

            handler.Unregister(device_token)

        /*
        * Request is to update the information about the provider
        */
        case "update_provider_information":
            fmt.Println("Updating provider information")

            device_token := request.FormValue("device_token")
            
            first_name := request.FormValue("first_name")
            last_name := request.FormValue("last_name")
            phone_number := request.FormValue("phone_number")

            handler.UpdateProviderInformation(device_token, first_name, last_name, phone_number)

        /*
        * Request is to retrieve all ongoing incidents relative to a dispatcher
        */
        case "retrieve_incidents":
            fmt.Println("Retrieving ongoing incidents")

            dispatcher_id := request.FormValue("dispatcher_id")

            result := handler.RetrieveOngoingIncidents(dispatcher_id)

            json, err := json.Marshal(result)

            if err != nil{
                panic(err.Error())
            }

            string_json := string(json)

            io.WriteString(writer, string_json)


        /*
        * Request is a connection test
        */
        case "connection_test":
            fmt.Println("Loud and clear")
    }
}


/*
* Start server on port 8000
*/
func main(){
    fmt.Println("SERVER RUNNING")
    http.HandleFunc("/", handleRequest)
    http.ListenAndServe(":8000", nil)
}
package dispatch

import "database/sql"
import notifications "notifications"
import "github.com/kellydunn/golang-geo"
import "strconv"

var db_info = "root:@/naloxone"

/*
*
* Function to dispatch the incident that has just occurred
* 
* 1. Retrieve the incident information
* 2. Retrieve all providers
* 3. Determine who is eligible to be dispatched
* 4. Send dispatch event to each mobile device with appropriate information
*
* @param incident - the id of the incident that has just occurred
* @returns the boolean value of if the dispatch was successful or not
*/
func Dispatch(incident string) bool{
    db, err := sql.Open("mysql", db_info)

    if err != nil{
        panic(err.Error())
    }

    // Retrieve specific incident information
    select_raw := "SELECT longitude, latitude, notes FROM incidents WHERE incident_id = ?"
    select_stmt, err := db.Prepare(select_raw)

    if err != nil{
        panic(err.Error())
    }

    // Longitude and latitude of incident
    var(
        longitude string
        latitude string
        notes string
    )

    // Fill longitude and latitude variables with query result
    err = select_stmt.QueryRow(incident).Scan(&longitude, &latitude, &notes)

    if err != nil{
        panic(err.Error())
    }

    latitude_float, err := strconv.ParseFloat(latitude, 64)

    if err != nil{
        panic(err.Error())
    }

    longitude_float, err := strconv.ParseFloat(longitude, 64)

    if err != nil{
        panic(err.Error())
    }

    // Retrieve eligible providers
    providers := EligibleProviders(latitude_float, longitude_float)

    // Send push notification to those providers with dispatch information
    for _ , device := range providers{
        details := make(map[string] string, 0)
        details["latitude"] = latitude
        details["longitude"] = longitude
        details["notes"] = notes
        details["incident_id"] = incident
        notifications.SendNotification(device, details, true)
    }

    return true
}


/*
* Given a longitude and latitude, returns a list of 
* providers (represented by their provider_id) that are eligible
* to respond to the incident.
*
* @param longitude - floating point value representing the longitude of the incident
* @param latitude - floating point value representing the latitude of the incident
*/
func EligibleProviders(latitude float64, longitude float64) []string{

    var result []string

    incident_loc := geo.NewPoint(latitude, longitude)

    db, err := sql.Open("mysql", db_info)

    if err != nil{
        panic(err.Error())
    }

    // Retrieve specific incident information
    select_raw := "SELECT provider_id, latitude, longitude, device_token FROM providers"
    rows, err := db.Query(select_raw)

    var(
        provider_id string
        provider_latitude float64
        provider_longitude float64
        device_token string
    )
    
    for rows.Next(){

        err := rows.Scan(&provider_id, &provider_latitude, &provider_longitude, &device_token)
        if err != nil{
            panic(err.Error())
        }

        p := geo.NewPoint(provider_latitude, provider_longitude)

        dist := incident_loc.GreatCircleDistance(p)

        // If the distance between the incident and the provider is less than or equal to 3 kilometers...
        if dist <= 3.0{
            result = append(result, device_token)
        }
    }

    return result
}


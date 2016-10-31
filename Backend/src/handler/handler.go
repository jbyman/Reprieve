package handler

import "database/sql"
import "time"
import _ "github.com/go-sql-driver/mysql"

var db_info = "root@/naloxone"

/*
*
* Function to add a provider to the database
*
* @param first_name - the first name of the new provider
* @param last_name - the last name of the new provider
* @param phone_number - the phone number of the new provider
* @returns the provider id of the new provider
*/
func AddProvider(first_name string, last_name string, phone_number string, latitude float64, longitude float64, device_token string) int{
    db, err := sql.Open("mysql", db_info)

    if err != nil{
        panic(err.Error())
    }

    insert_raw := "INSERT INTO providers(first_name, last_name, phone_number, longitude, latitude, device_token) VALUES(?, ?, ?, ?, ?, ?)"
    insert_stmt, err := db.Prepare(insert_raw)

    if err != nil{
        panic(err.Error())
    }

    res, err := insert_stmt.Exec(first_name, last_name, phone_number, longitude, latitude, device_token)

    if err != nil{
        panic(err.Error())
    }

    // Get last inserted ID
    provider, err := res.LastInsertId()

    if err != nil{
        panic(err.Error())
    }

    return int(provider)
}

/*
*
* Function to handle a new incident request. Inserts the incident into the database
*
* @param longitude - floating point value representing the longitude of the incident
* @param latitude - floating point value representing the latitude of the incident
* @returns the id of the incident that was just inserted 
*/
func NewIncident(dispatch_id int, longitude float64, latitude float64, notes string) int{

    db, err := sql.Open("mysql", db_info)

    if err != nil{
        panic(err.Error())
    }

    insert_raw := "INSERT INTO incidents(longitude, latitude, recorded, dispatch_id, notes) VALUES(?, ?, ?, ?, ?)"
    insert_stmt, err := db.Prepare(insert_raw)

    if err != nil{
        panic(err.Error())
    }

    // Execute prepared insert statement
    res, err := insert_stmt.Exec(longitude, latitude, time.Now(), dispatch_id, notes)

    if err != nil{
        panic(err.Error())
    }


    // Get last inserted ID
    id, err := res.LastInsertId()

    if err != nil{
        panic(err.Error())
    }

    return int(id)
}


/*
*
* Function to update the recorded location of the provider. Should be hit every 10 minutes by each provider.
*
* @param longitude - floating point value representing the longitude of the incident
* @param latitude - floating point value representing the latitude of the incident
* @returns true if the provider location was updated successfully 
*/
func UpdateProviderLocation(provider_id int, latitude float64, longitude float64) bool{
    db, err := sql.Open("mysql", db_info)
    if err != nil{
        panic(err.Error())
    }

    update_raw := "UPDATE providers SET latitude = ?, longitude = ? WHERE provider_id = ?"
    update_stmt, err := db.Prepare(update_raw)

    if err != nil{
        panic(err.Error())
    }

    // Execute prepared update statement
    _, err = update_stmt.Exec(latitude, longitude, provider_id)

    if err != nil{
        panic(err.Error())
    }

    return true
}

/*
*
* Function to indicate that a provider has accepted the dispatch request
*
* @param device_token - the provider that has accepted the request
* @param incident_id - the incident the provider is responding to
* @returns whether the request was successful
*/
func ProviderAcceptsRequest(device_token string, incident_id int) bool{

    db, err := sql.Open("mysql", db_info)
    if err != nil{
        panic(err.Error())
    }

    insert_raw := "INSERT INTO responders(device_token, incident_id) VALUES(?, ?)"
    insert_stmt, err := db.Prepare(insert_raw)


    // Execute prepared insert statement
    _, err = insert_stmt.Exec(device_token, incident_id)

    if err != nil{
        panic(err.Error())
    }

    return true
}

/*
*
* Function to indicate that an incident has ended,
* either at the end of a call, or if the dispatcher
* should not have dispatched the incident
*
* @param incident_id - the incident that has just ended
* @returns whether ending the incident was successful
*/
func EndOrCancelIncident(incident_id int) bool{
    db, err := sql.Open("mysql", db_info)

    if err != nil{
        panic(err.Error())
    }

    // Remove responders from that incident
    delete_raw := "DELETE FROM responders WHERE incident_id = ?"
    delete_stmt, err := db.Prepare(delete_raw)

    _, err = delete_stmt.Exec(incident_id)

    if err != nil{
        panic(err.Error())
    }

    // Remove incident from active incidents table
    delete_raw = "DELETE FROM incidents WHERE incident_id = ?"
    delete_stmt, err = db.Prepare(delete_raw)

    _, err = delete_stmt.Exec(incident_id)

    if err != nil{
        panic(err.Error())
    }

    return true
}

/*
*
* Function to update a provider's information
*
* @param device_token - the provider you are updating
* @param first_name - the updated first name
* @param last_name - the updated last name
* @param phone_number - the updated phone number
* @returns whether the update was successful
*/
func UpdateProviderInformation(device_token string, first_name string, last_name string, phone_number string) bool{
    db, err := sql.Open("mysql", db_info)

    if err != nil{
        panic(err.Error())
    }

    // Remove responders from that incident
    update_raw := "UPDATE providers SET first_name = ?, last_name = ?, phone_number = ? WHERE device_token = ?"
    update_stmt, err := db.Prepare(update_raw)

    _, err = update_stmt.Exec(device_token, first_name, last_name, phone_number)

    if err != nil{
        panic(err.Error())
    }

    return true
}


/*
* 
* Function to unregister a provider
*
* @param device_token - the device to unregister
* @returns whether the provider was successfully unregistered
*/
func Unregister(device_token string) bool{
    db, err := sql.Open("mysql", db_info)

    if err != nil{
        panic(err.Error())
    }

    delete_raw := "DELETE FROM providers WHERE device_token = ?"
    delete_stmt, err := db.Prepare(delete_raw)

    _, err = delete_stmt.Exec(device_token)

    if err != nil{
        panic(err.Error())
    }

    return true
}

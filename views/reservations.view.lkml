view: reservations {
  sql_table_name: `case_study.reservations` ;;
  drill_fields: [details*]

  dimension: primary_key {
    type: string
    primary_key: yes
    hidden: yes
    sql: GENERATE_UUID() ;;
  }

  dimension: bd_ba {
    label: "Bedrooms/Baths"
    type: string
    sql: ${TABLE}.BD_BA ;;
  }

  dimension: bedrooms {
    label: "Bedrooms"
    type: string
    sql: SPLIT(${bd_ba}, '/')[OFFSET(0)] ;;
  }

  dimension: bathrooms {
    label: "Bathrooms"
    type: string
    sql: SPLIT(${bd_ba}, '/')[OFFSET(1)] ;;
  }

  dimension_group: booking {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Booking_Date ;;
  }

  dimension: booking_source {
    type: string
    sql: ${TABLE}.Booking_Source ;;
  }

  dimension: building_name {
    type: string
    sql: ${TABLE}.Building_Name ;;
  }

  dimension_group: check_in {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Check_in_Date ;;
  }

  dimension_group: check_out {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Check_out_Date ;;
  }

  dimension: guest_id {
    type: string
    sql: ${TABLE}.Guest_ID ;;
  }

  dimension: reservation_status {
    type: string
    sql: ${TABLE}.Reservation_Status ;;
  }

  dimension: revenue {
    type: number
    sql: ${TABLE}.Revenue ;;
  }

  measure: count {
    type: count
    drill_fields: [building_name]
  }

  measure: count_completed {
    type: count
    drill_fields: []
    filters: [
      reservation_status: "completed"
    ]
  }

  measure: count_guests {
    type: count_distinct
    sql: ${guest_id} ;;
    drill_fields: [building_name]
  }

  set: details {
    fields: [

    ]
  }
}

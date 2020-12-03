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
    description: "Number of Bedrooms (BD) and number of Baths (BA)"
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
    description: "Date the guest booked the reservation"
    type: time
    timeframes: [
      raw,
      date,
      day_of_week,
      day_of_week_index,
      week,
      month,
      month_name,
      month_num,
      quarter,
      quarter_of_year,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Booking_Date ;;
  }

  dimension: booking_source {
    description: "Source where the guest made their reservation"
    type: string
    sql: ${TABLE}.Booking_Source ;;
  }

  dimension: building_name {
    description: "Name of the building the unit is in"
    type: string
    sql: ${TABLE}.Building_Name ;;
  }

  dimension_group: check_in {
    description: "Date the guest's reservation started. For canceled bookings, this is the date the reservation was planned to start"
    type: time
    timeframes: [
      raw,
      date,
      day_of_week,
      day_of_week_index,
      week,
      month,
      month_name,
      month_num,
      quarter,
      quarter_of_year,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Check_in_Date ;;
  }

  dimension_group: check_out {
    description: "Date the guest's reservation ended. For canceled bookings, this is the date the reservation was planned to end"
    type: time
    timeframes: [
      raw,
      date,
      day_of_week,
      day_of_week_index,
      week,
      month,
      month_name,
      month_num,
      quarter,
      quarter_of_year,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Check_out_Date ;;
  }

  dimension: duration_days {
    type: duration_day
    value_format_name: decimal_0
    sql_start: CAST(${check_in_raw} AS TIMESTAMP) ;;
    sql_end: CAST(${check_out_raw} AS TIMESTAMP) ;;
  }

  dimension: guest_id {
    description: "Unique ID assigned to each guest"
    type: string
    sql: ${TABLE}.Guest_ID ;;
  }

  dimension: reservation_status {
    description: "Status of the guest's reservation"
    type: string
    sql: ${TABLE}.Reservation_Status ;;
  }

  dimension: revenue {
    description: "Total revenue charged to the guest"
    type: number
    value_format_name: usd
    sql: ${TABLE}.Revenue ;;
  }

  # MEASURES
  measure: avg_revenue {
    label: "Average Revenue"
    type: average
    value_format_name: usd
    drill_fields: [details*]
    sql: ${revenue} ;;
  }

  measure: avg_duration {
    label: "Average Duration"
    type: average
    value_format_name: decimal_1
    drill_fields: [details*]
    sql: ${duration_days} ;;
  }

  measure: count {
    type: count
    drill_fields: [details*]
  }

  measure: count_completed {
    type: count
    drill_fields: [details*]
    filters: [
      reservation_status: "completed"
    ]
  }

  measure: count_canceled {
    type: count
    drill_fields: [details*]
    filters: [
      reservation_status: "canceled"
    ]
  }

  measure: count_inquiry {
    type: count
    drill_fields: [details*]
    filters: [
      reservation_status: "inquiry"
    ]
  }

  measure: count_airbnb {
    label: "Count Airbnb"
    type: count
    drill_fields: [details*]
    filters: [
      booking_source: "Airbnb",
      reservation_status: "completed"
    ]
  }

  measure: count_booking {
    label: "Count Booking.com"
    type: count
    drill_fields: [details*]
    filters: [
      booking_source: "Booking.com",
      reservation_status: "completed"
    ]
  }

  measure: count_expedia {
    label: "Count Expedia"
    type: count
    drill_fields: [details*]
    filters: [
      booking_source: "Expedia",
      reservation_status: "completed"
    ]
  }

  measure: count_kasa {
    label: "Count Kasa.com"
    type: count
    drill_fields: [details*]
    filters: [
      booking_source: "Kasa.com",
      reservation_status: "completed"
    ]
  }

  measure: count_guests {
    type: count_distinct
    sql: ${guest_id} ;;
    drill_fields: [details*]
  }

  measure: count_check_days {
    type: count_distinct
    sql: ${check_in_raw} ;;
    drill_fields: [details*]
  }

  measure: max_booking_date {
    type: date
    convert_tz: no
    sql: MAX(${booking_raw}) ;;
  }

  measure: min_booking_date {
    type: date
    convert_tz: no
    sql: MIN(${booking_raw}) ;;
  }

  measure: max_check_in_date {
    type: date
    convert_tz: no
    sql: MAX(${check_in_raw}) ;;
  }

  measure: min_check_in_date {
    type: date
    convert_tz: no
    sql: MIN(${check_in_raw}) ;;
  }

  measure: max_check_out_date {
    type: date
    convert_tz: no
    sql: MAX(${check_out_raw}) ;;
  }

  measure: min_check_out_date {
    type: date
    convert_tz: no
    sql: MIN(${check_out_raw}) ;;
  }

  measure: occupancy_rate {
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${count} / NULLIF(${buildings.total_units}, 0) ;;
  }

  measure: total_revenue {
    label: "Revenue $"
    type: sum
    value_format_name: usd_0
    drill_fields: [details*]
    sql: ${revenue} ;;
  }

  measure: total_revenue_completed {
    label: "Revenue Completed $"
    type: sum
    value_format_name: usd_0
    drill_fields: [details*]
    sql: ${revenue} ;;
    filters: [
      reservation_status: "completed"
    ]
  }

  measure: total_revenue_airbnb {
    label: "Airbnb $"
    type: sum
    value_format_name: usd_0
    drill_fields: [details*]
    sql: ${revenue} ;;
    filters: [
      booking_source: "Airbnb",
      reservation_status: "completed"
    ]
  }

  measure: total_revenue_booking {
    label: "Booking.com $"
    type: sum
    value_format_name: usd_0
    drill_fields: [details*]
    sql: ${revenue} ;;
    filters: [
      booking_source: "Booking.com",
      reservation_status: "completed"
    ]
  }

  measure: total_revenue_expedia {
    label: "Expedia $"
    type: sum
    value_format_name: usd_0
    drill_fields: [details*]
    sql: ${revenue} ;;
    filters: [
      booking_source: "Expedia",
      reservation_status: "completed"
    ]
  }

  measure: total_revenue_kasa {
    label: "Kasa.com $"
    type: sum
    value_format_name: usd_0
    drill_fields: [details*]
    sql: ${revenue} ;;
    filters: [
      booking_source: "Kasa.com",
      reservation_status: "completed"
    ]
  }

  measure: total_duration {
    label: "Total Duration"
    type: sum
    value_format_name: decimal_1
    drill_fields: [details*]
    sql: ${duration_days} ;;
  }


  set: details {
    fields: [
      building_name,
      building.metro,
      bd_ba,
      reservation_status,
      booking_source,
      booking_date,
      check_in_date,
      check_out_date,
      duration_days,
      revenue
    ]
  }
}

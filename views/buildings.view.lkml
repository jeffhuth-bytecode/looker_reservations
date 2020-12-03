view: buildings {
  sql_table_name: `case_study.buildings` ;;
  drill_fields: [details*]

  dimension: building_name {
    description: "Name of the building the unit is in"
    type: string
    primary_key: yes
    sql: ${TABLE}.Building_Name ;;
  }

  dimension: kasa_units {
  description: "Number of active units in each building"
    type: number
    sql: ${TABLE}.Kasa_Units ;;
  }

  dimension: metro {
    description: "Major metro the building is located in"
    type: string
    sql: ${TABLE}.Metro ;;
  }

  measure: count {
    type: count
    drill_fields: [details*]
  }

  measure: avg_units {
    label: "Average Units"
    type: average
    sql: ${kasa_units} ;;
    value_format_name: decimal_1
    drill_fields: [details*]
  }

  measure: total_units {
    type: sum
    sql: ${kasa_units} ;;
    drill_fields: [details*]
  }

  set: details {
    fields: [
      building_name,
      metro,
      kasa_units
    ]
  }


}

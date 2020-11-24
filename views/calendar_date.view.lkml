# Reference: https://gist.github.com/ewhauser/d7dd635ad2d4b20331c7f18038f04817
view: calendar_date {
  derived_table: {
    sql: SELECT
        FORMAT_DATE('%F', d) as id,
        d AS calendar_date,
        (CASE WHEN FORMAT_DATE('%A', d) IN ('Sunday', 'Saturday') THEN TRUE ELSE FALSE END) AS day_is_weekday,
        (CASE WHEN FORMAT_DATE('%A', d) IN ('Sunday', 'Saturday') THEN FALSE ELSE TRUE END) AS day_is_weekend
      FROM (
        SELECT
          *
        FROM
          UNNEST(GENERATE_DATE_ARRAY('2019-01-01', '2021-01-01', INTERVAL 1 DAY)) AS d )
       ;;
  }
  drill_fields: [detail*]

  dimension: id {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension_group: calendar {
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
    sql: ${TABLE}.calendar_date ;;
  }

  dimension: day_is_weekday {
    type: yesno
    sql: ${TABLE}.day_is_weekday ;;
  }

  dimension: day_is_weekend {
    type: yesno
    sql: ${TABLE}.day_is_weekend ;;
  }

  # MEASURES
  measure: count {
    type: count
  }

  set: detail {
    fields: [calendar_date, day_is_weekday, day_is_weekend]
  }
}

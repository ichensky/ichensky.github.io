---
layout: post
title:  "Time notes"
date:   2023-08-07 22:51:02 +0300
categories: time
---

## Time Scale 

[**International Atomic Time (TIA)**](https://en.wikipedia.org/wiki/International_Atomic_Time) is a man-made, laboratory timescale. Its units the **SI seconds** which is based on the frequency of the cesium-133 atom. **TAI** is the International Atomic Time scale, a statistical timescale based on a large number of atomic clocks.

[**Coordinated Universal Time (UTC)**](https://en.wikipedia.org/wiki/Coordinated_Universal_Time) – UTC is the basis of civil timekeeping. The UTC uses the **SI second**, which is an atomic time, as it fundamental unit. The UTC is kept in time with the Earth rotation. However, the rate of the Earth rotation is not uniform (with respect to atomic time). To compensate a [leap second](https://www.nist.gov/pml/time-and-frequency-division/time-realization/leap-seconds) is added usually at the end of June or December about every 18 months.
Also the earth is divided in to standard-time zones, and UTC differs by an integral number of hours between time zones (parts of Canada and Australia differ by n+0.5 hours). You local time is UTC adjusted by your timezone offset.

[**Universal Time (UT1)**](https://en.wikipedia.org/wiki/Universal_Time) – Universal time or, more specifically UT1, is counted from 0 hours at midnight, with unit of duration the mean solar day, defined to be as uniform as possible despite variations in the rotation of the Earth. It is observed as the diurnal motion of stars or
extraterrestrial radio sources. It is continuous (no leap second), but has a variable rate due the Earth’s non-uniform rotational period. It is needed for computing sidereal time. To obtain UT1 you need to look up the ut1-utc value published by the International Earth Rotation Service. This quantity, kept in range +- 0.9s by means of the UTC leap seconds. 

[Greenwich Mean Time](https://en.wikipedia.org/wiki/Greenwich_Mean_Time) - GMT (an archaic term that is deprecated except in Great Britain) has now become just another name for the time zone `UTC+0`.

## Second 

[**Second**](https://en.wikipedia.org/wiki/Second) is defined by taking the fixed numerical value of the caesium frequency, ΔνCs, the unperturbed ground-state hyperfine transition frequency of the caesium 133 atom, to be 9 192 631 770 when expressed in the unit Hz, which is equal to s−1.

## Time dilation

[**Time dilation**](https://en.wikipedia.org/wiki/Time_dilation) is the difference in elapsed time as measured by two clocks, either due to a relative velocity between them (special relativity) or due to a difference in gravitational potential between their locations (general relativity). 
see [Hafele–Keating experiment](https://en.wikipedia.org/wiki/Hafele%E2%80%93Keating_experiment)

## Proper time

[**Proper time**](https://en.wikipedia.org/wiki/Proper_time) along a timelike world line is defined as the time as measured by a clock following that line. The proper time interval between two events on a world line is the change in proper time, which is independent of coordinates, and is a **Lorentz scalar**. The interval is the quantity of interest, since proper time itself is fixed only up to an arbitrary additive constant, namely the setting of the clock at some event along the world line.

## Epoch
An [**epoch**](https://en.wikipedia.org/wiki/Epoch_(computing)) is a fixed date and time used as a reference from which a computer measures system time. For instance, Unix and POSIX measure time as the number of seconds that have passed since Thursday 1 January 1970 00:00:00 UT, a point in time known as the [Unix epoch](https://en.wikipedia.org/wiki/Unix_time).
For *Microsoft .Net* epoch date is `1 January AD 1` see [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)
For *Javascript* epoch date is `1 January 1970` - Unix Epoch.


## System time
[**System time**](https://en.wikipedia.org/wiki/System_time) represents a computer system's notion of the passage of time. In this sense, time also includes the passing of days on the calendar.
System time can be converted into calendar time, which is a form more suitable for human comprehension. 
The Unix system time 1000000000 seconds since the beginning of the epoch translates into the calendar time 9 September 2001 01:46:40 UT. 

## Real-time clock
A [real-time clock](https://en.wikipedia.org/wiki/Real-time_clock) (RTC) is an electronic device (most often in the form of an integrated circuit) that measures the passage of time. Most RTCs use a crystal *oscillator*, but some have the option of using the power line frequency. The crystal frequency is usually 32.768 kHz, the same frequency used in quartz clocks and watches.

## Calendar

A [calendar](https://en.wikipedia.org/wiki/Calendar) is a system of organizing days. 
The [Gregorian calendar](https://en.wikipedia.org/wiki/Gregorian_calendar) is the de facto international standard and is used almost everywhere in the world for civil purposes.

## Time zone

A [time zone](https://en.wikipedia.org/wiki/Time_zone) is an area which observes a uniform standard time for legal, commercial and social purposes. Time zones tend to follow the boundaries between countries and their subdivisions instead of strictly following longitude, because it is convenient for areas in frequent communication to keep the same time.

## Daylight saving time
[Daylight saving time](https://en.wikipedia.org/wiki/Daylight_saving_time) (DST), also referred to as daylight savings time, daylight time (United States, Canada, and Australia), or summer time (United Kingdom, European Union, and others), is the practice of advancing clocks (typically by one hour) during warmer months so that darkness falls at a later clock time.

## Network Time Protocol
[The Network Time Protocol](https://en.wikipedia.org/wiki/Network_Time_Protocol) (NTP) is a networking protocol for [**clock synchronization**](https://en.wikipedia.org/wiki/Clock_synchronization) between computer systems over packet-switched, variable-latency data networks. 
NTP can usually maintain time to within tens of milliseconds over the public Internet, and can achieve better than one millisecond accuracy in local area networks under ideal conditions.

## ISO 8601
[**ISO 8601**](https://en.wikipedia.org/wiki/ISO_8601) is a standard established by the International Organization for Standardization defining methods of representing dates and times in textual form, including specifications for representing time zones.
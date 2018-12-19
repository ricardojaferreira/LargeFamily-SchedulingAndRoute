%sumMinToTime(_Time,_AddMinutes,_FinalTime)
%   _Time: The base time in the format HHMM
%   _AddMinutes: The number of minutes to add
%   _FinalTime: The result of adding _AddMinutes to _Times in the format HHMM
%
%   This function add minutes to a time in the format HHMM.
%
sumMinToTime(Time,0,Time).
sumMinToTime(Time,AddMinutes,FinalTime):-
    Hours is truncate(Time/100),
    Minutes is round(100*float_fractional_part(Time/100)),
    Hours>=24,
    H is Hours-24,
    T is H*100 + Minutes,
    sumMinToTime(T,AddMinutes,FinalTime).

sumMinToTime(Time,AddMinutes,FinalTime):-
    AddMinutes > 60,
    Add is AddMinutes - 60,
    T is Time+100,
    sumMinToTime(T,Add,FinalTime).

sumMinToTime(Time,AddMinutes,FinalTime):-
    Hours is truncate(Time/100),
    Minutes is round(100*float_fractional_part(Time/100)),
    Minutes > 60,
    H is Hours + 1,
    M is Minutes - 60,
    T is H*100 + M,
    sumMinToTime(T,AddMinutes,FinalTime).

sumMinToTime(Time,AddMinutes,FinalTime):-
    Hours is truncate(Time/100),
    Minutes is round(100*float_fractional_part(Time/100)),
    M is Minutes + AddMinutes,
    M >= 100,
    H is Hours +1,
    M1 is M - 60,
    T is H*100 + M1,
    sumMinToTime(T,0,FinalTime).

sumMinToTime(Time,AddMinutes,FinalTime):-
    Hours is truncate(Time/100),
    Minutes is round(100*float_fractional_part(Time/100)),
    M is Minutes + AddMinutes,
    M >= 60,
    H is Hours +1,
    M1 is M - 60,
    T is H*100 + M1,
    sumMinToTime(T,0,FinalTime).

sumMinToTime(Time,AddMinutes,FinalTime):-
    AddMinutes > 0,
    Hours is truncate(Time/100),
    Minutes is round(100*float_fractional_part(Time/100)),
    M is Minutes + AddMinutes,
    T is Hours*100 + M,
    sumMinToTime(T,0,FinalTime).

%subtract times

% 1740 - 1820 = 20 + 20 = 20min

subtractTimes(TimeA,TimeB,FinalTime):-
    subtractTimes(TimeA,TimeB,0,FinalTime).

subtractTimes(0,0,FinalTime,FinalTime).
subtractTimes(TimeA,TimeB,StartTime,FinalTime):-
    HourA is truncate(TimeA/100),
    HourB is truncate(TimeB/100),
    HourA < HourB,
    MinuteA is round(100*float_fractional_part(TimeA/100)),
    DiffMinute is 60 - MinuteA,
    sumMinToTime(TimeA,60,T),
    NewTimeA is (truncate(T/100)*100),
    Temp is StartTime+DiffMinute,
    subtractTimes(NewTimeA,TimeB,Temp,FinalTime).

subtractTimes(TimeA,TimeB,StartTime,FinalTime):-
    HourA is truncate(TimeA/100),
    HourB is truncate(TimeB/100),
    HourA > HourB,
    MinuteB is round(100*float_fractional_part(TimeB/100)),
    DiffMinute is 60 - MinuteB,
    sumMinToTime(TimeB,60,T),
    NewTimeB is (truncate(T/100)*100),
    Temp is StartTime+DiffMinute,
    subtractTimes(TimeA,NewTimeB,Temp,FinalTime).

subtractTimes(TimeA,TimeB,StartTime,FinalTime):-
    HourA is truncate(TimeA/100),
    HourB is truncate(TimeB/100),
    HourA == HourB,
    MinuteA is round(100*float_fractional_part(TimeA/100)),
    MinuteB is round(100*float_fractional_part(TimeB/100)),
    DiffMinute is abs(MinuteA-MinuteB),
    Temp is StartTime+DiffMinute,
    subtractTimes(0,0,Temp,FinalTime).




%sumMinToTime(_Time,_AddMinutes,_FinalTime)
%   _Time: The base time in the format HHMM
%   _AddMinutes: The number of minutes to add
%   _FinalTime: The result of adding _AddMinutes to _Times in the format HHMM
%
%   This function add minutes to a time in the format HHMM.
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

sumMinToTime(Time,0,Time).


%subtractMinToTime(_Time,_SubMinutes,_FinalTime)
%   _Time: The base time in the format HHMM
%   _SubMinutes: The number of minutes to subtract
%   _FinalTime: The result of subtracting _SubMinutes to _Times in the format HHMM
%
%   This function subtracts minutes to a time in the format HHMM.
% consult('TimeUtils.pl').
subtractMinToTime(Time,0,Time).
subtractMinToTime(Time,SubMinutes,FinalTime):-
    SubMinutes > 60,
    Subtract is SubMinutes - 60,
    Time >= 100,
    T is Time-100,
    sumMinToTime(T,Subtract,FinalTime).

subtractMinToTime(Time,SubMinutes,FinalTime):-
    SubMinutes > 60,
    Subtract is SubMinutes - 60,
    Time < 100,
    T is 23*100 + Time, %Time is only minutes
    sumMinToTime(T,Subtract,FinalTime).

subtractMinToTime(Time,SubMinutes,FinalTime):-
    Time >= 100,
    Minutes is round(100*float_fractional_part(Time/100)),
    SubMinutes > Minutes,
    M is 60 - (SubMinutes - Minutes),
    Hours is truncate(Time/100),
    H is Hours - 1,
    T is H*100 + M,
    subtractMinToTime(T,0,FinalTime).

subtractMinToTime(Time,SubMinutes,FinalTime):-
    Time < 100,
    SubMinutes > Time,
    M is 60 - (SubMinutes - Time),
    T is 23*100 + M,
    subtractMinToTime(T,0,FinalTime).

subtractMinToTime(Time,SubMinutes,FinalTime):-
    Minutes is round(100*float_fractional_part(Time/100)),
    M is Minutes - SubMinutes,
    Hours is truncate(Time/100),
    T is Hours*100 + M,
    subtractMinToTime(T,0,FinalTime).


%diffTimes(_TimeA,_TimeB,Difference)
%   _TimeA: Time in the format HHMM
%   _TimeB: Time in the format HHMM
%   Difference: The difference between TimeA and Time B in Minutes
%
%   This function calculate the difference in minutes of two periods in 
%   the format HHMM.
%
diffTimes(TimeA,TimeB,Difference):-
    diffTimes(TimeA,TimeB,0,Difference).

diffTimes(0,0,Difference,Difference).
diffTimes(TimeA,TimeB,StartTime,Difference):-
    HourA is truncate(TimeA/100),
    HourB is truncate(TimeB/100),
    HourA < HourB,
    MinuteA is round(100*float_fractional_part(TimeA/100)),
    DiffMinute is 60 - MinuteA,
    sumMinToTime(TimeA,60,T),
    NewTimeA is (truncate(T/100)*100),
    Temp is StartTime+DiffMinute,
    diffTimes(NewTimeA,TimeB,Temp,Difference).

diffTimes(TimeA,TimeB,StartTime,Difference):-
    HourA is truncate(TimeA/100),
    HourB is truncate(TimeB/100),
    HourA > HourB,
    MinuteB is round(100*float_fractional_part(TimeB/100)),
    DiffMinute is 60 - MinuteB,
    sumMinToTime(TimeB,60,T),
    NewTimeB is (truncate(T/100)*100),
    Temp is StartTime+DiffMinute,
    diffTimes(TimeA,NewTimeB,Temp,Difference).

diffTimes(TimeA,TimeB,StartTime,Difference):-
    HourA is truncate(TimeA/100),
    HourB is truncate(TimeB/100),
    HourA == HourB,
    MinuteA is round(100*float_fractional_part(TimeA/100)),
    MinuteB is round(100*float_fractional_part(TimeB/100)),
    DiffMinute is abs(MinuteA-MinuteB),
    Temp is StartTime+DiffMinute,
    diffTimes(0,0,Temp,Difference).




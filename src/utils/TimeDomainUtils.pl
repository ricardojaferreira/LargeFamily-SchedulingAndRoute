%sumMinToTime(_Time,_AddMinutes,_FinalTime)
%   _Time: The base time in the format HHMM
%   _AddMinutes: The number of minutes to add
%   _FinalTime: The result of adding _AddMinutes to _Times in the format HHMM
%
%   This function add minutes to a time in the format HHMM.
sumMinToTime(Time,AddMinutes,FinalTime):-
    Hours #= truncate(Time/100),
    Minutes #= round(100*float_fractional_part(Time/100)),
    Hours#>=24,
    H #= Hours-24,
    T #= H*100 + Minutes,
    sumMinToTime(T,AddMinutes,FinalTime).

sumMinToTime(Time,AddMinutes,FinalTime):-
    AddMinutes #> 60,
    Add #= AddMinutes - 60,
    T #= Time+100,
    sumMinToTime(T,Add,FinalTime).

sumMinToTime(Time,AddMinutes,FinalTime):-
    Hours #= truncate(Time/100),
    Minutes #= round(100*float_fractional_part(Time/100)),
    M is Minutes + AddMinutes,
    M #>= 60,
    H #= Hours +1,
    M1 #= M - 60,
    T #= H*100 + M1,
    sumMinToTime(T,0,FinalTime).

sumMinToTime(Time,AddMinutes,FinalTime):-
    AddMinutes #> 0,
    Hours #= truncate(Time/100),
    Minutes #= round(100*float_fractional_part(Time/100)),
    M #= Minutes + AddMinutes,
    T #= Hours*100 + M,
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
    SubMinutes #> 60,
    Subtract is SubMinutes - 60,
    Time #>= 100,
    T #= Time-100,
    sumMinToTime(T,Subtract,FinalTime).

subtractMinToTime(Time,SubMinutes,FinalTime):-
    SubMinutes #> 60,
    Subtract #= SubMinutes - 60,
    Time #< 100,
    T #= 23*100 + Time, %Time is only minutes
    sumMinToTime(T,Subtract,FinalTime).

subtractMinToTime(Time,SubMinutes,FinalTime):-
    Time #>= 100,
    Minutes #= round(100*float_fractional_part(Time/100)),
    SubMinutes > Minutes,
    M #= 60 - (SubMinutes - Minutes),
    Hours is truncate(Time/100),
    H #= Hours - 1,
    T #= H*100 + M,
    subtractMinToTime(T,0,FinalTime).

subtractMinToTime(Time,SubMinutes,FinalTime):-
    Time #< 100,
    SubMinutes #> Time,
    M #= 60 - (SubMinutes - Time),
    T #= 23*100 + M,
    subtractMinToTime(T,0,FinalTime).

subtractMinToTime(Time,SubMinutes,FinalTime):-
    Minutes #= round(100*float_fractional_part(Time/100)),
    M #= Minutes - SubMinutes,
    Hours #= truncate(Time/100),
    T #= Hours*100 + M,
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
    HourA #= truncate(TimeA/100),
    HourB #= truncate(TimeB/100),
    HourA #< HourB,
    MinuteA #= round(100*float_fractional_part(TimeA/100)),
    DiffMinute #= 60 - MinuteA,
    sumMinToTime(TimeA,60,T),
    NewTimeA #= (truncate(T/100)*100),
    Temp #= StartTime+DiffMinute,
    diffTimes(NewTimeA,TimeB,Temp,Difference).

diffTimes(TimeA,TimeB,StartTime,Difference):-
    HourA #= truncate(TimeA/100),
    HourB #= truncate(TimeB/100),
    HourA #> HourB,
    MinuteB #= round(100*float_fractional_part(TimeB/100)),
    DiffMinute #= 60 - MinuteB,
    sumMinToTime(TimeB,60,T),
    NewTimeB #= (truncate(T/100)*100),
    Temp #= StartTime+DiffMinute,
    diffTimes(TimeA,NewTimeB,Temp,Difference).

diffTimes(TimeA,TimeB,StartTime,Difference):-
    HourA #= truncate(TimeA/100),
    HourB #= truncate(TimeB/100),
    HourA #= HourB #<=> B,
    B #= 1,
    MinuteA #= round(100*float_fractional_part(TimeA/100)),
    MinuteB #= round(100*float_fractional_part(TimeB/100)),
    DiffMinute #= abs(MinuteA-MinuteB),
    Temp #= StartTime+DiffMinute,
    diffTimes(0,0,Temp,Difference).

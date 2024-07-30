CREATE TABLE JUDGE (SSN CHAR(5), Name CHAR(10), Surname CHAR(10), BirthDate DATE);
CREATE TABLE COURT (CodCourt CHAR(5), CourtName CHAR(10), City CHAR(10));
CREATE TABLE COURTROOM (CodCourt CHAR(5), CodRoom CHAR(10), RoomName CHAR(10));
CREATE TABLE LAWSUIT (CodLawsuit CHAR(5), LawsuitType CHAR(10), StartDate DATE, EndDate DATE, SSN CHAR(5));
CREATE TABLE COURT_HEARING (CodCourt CHAR(5), CodRoom CHAR(5), Sana DATE, StartTime TIME, EndTime TIME, CodLawsuit CHAR(5));

INSERT INTO JUDGE VALUES("AA1", "Giovanni", "Vinardi", '1960-10-10');
INSERT INTO JUDGE VALUES("AA2", "Gianluca", "Sortino", '1990-10-10');
INSERT INTO JUDGE VALUES("AA3", "Federico", "Torricelli", '1980-10-10');

INSERT INTO COURT VALUES("CC1", "Justice", "Turin");
INSERT INTO COURT VALUES("CC2", "Adalat", "Tashkent");
INSERT INTO COURT VALUES("CC3", "Victory", "New-York");
INSERT INTO COURT VALUES("CC4", "Justice", "Milan");

INSERT INTO COURTROOM VALUES("CC1", "R01", "Main");
INSERT INTO COURTROOM VALUES("CC1", "R02", "Hall");
INSERT INTO COURTROOM VALUES("CC1", "R11", "Waiting");
INSERT INTO COURTROOM VALUES("CC1", "R05", "Office");
INSERT INTO COURTROOM VALUES("CC2", "R01", "Main");
INSERT INTO COURTROOM VALUES("CC2", "R02", "Hall");
INSERT INTO COURTROOM VALUES("CC3", "R11", "Waiting");
INSERT INTO COURTROOM VALUES("CC4", "R05", "Office");

INSERT INTO LAWSUIT VALUES("LL1", "Divorce", '2020-01-01', '2023-05-12', "AA1");
INSERT INTO LAWSUIT VALUES("LL2", "Defamation", '2018-01-02', '2023-05-12', "AA1");
INSERT INTO LAWSUIT VALUES("LL3", "Robbery", '2020-11-01', '2022-05-12', "AA2");
INSERT INTO LAWSUIT VALUES("LL4", "Divorce", '2020-01-01', '2023-01-15', "AA2");
INSERT INTO LAWSUIT VALUES("LL4", "Robbery", '2005-01-01', '2006-01-12', "AA1");

INSERT INTO COURT_HEARING VALUES("CC1", "R01", '2020-02-01', '09:00', '12:00', "LL1");
INSERT INTO COURT_HEARING VALUES("CC2", "R05", '2020-02-01', '12:00', '13:00', "LL4");
INSERT INTO COURT_HEARING values("CC4", "R11", '2019-02-01', '09:00', '12:00', "LL4");
INSERT INTO COURT_HEARING VALUES("CC4", "R05", '2020-12-01', '12:00', '13:00', "LL1");
INSERT INTO COURT_HEARING VALUES("CC3", "R11", '2005-02-01', '09:00', '12:00', "LL5");
INSERT INTO COURT_HEARING VALUES("CC2", "R02", '2021-02-01', '12:00', '13:00', "LL1");
-- a. For each judge who has never presided over any defamation lawsuit (LawsuitType = 'Defamation’)
-- in the year 2020, show SSN, surname and number of different types of lawsuits he has presided over.
SELECT J.SSN, Surname, COUNT(*)
FROM JUDGE J, LAWSUIT L
WHERE J.SSN = L.SSN AND J.SSN  NOT IN (SELECT SSN 
	FROM LAWSUIT L ,COURT_HEARING CH
	WHERE Sana>='2020-01-01' and Sana<='2020-12-12' and LawsuitType = 'Defamation' AND L.CodLawsuit=CH.CodLawsuit)
GROUP BY J.SSN;

-- b. Considering the lawsuits still pending and presided over by a judge who, overall over the course of
-- his career, has presided over court hearings in at least three different courts, show the code of each
-- lawsuit and the date of the last court hearing held for the cause.
SELECT CH.CodLawsuit, MAX(Sana)
FROM COURT_HEARING CH, LAWSUIT L
WHERE CH.CodLawsuit = L.CodLawsuit AND StartDate<=current_date AND Enddate>=current_date AND L.SSN IN (SELECT L1.SSN 
	FROM COURT_HEARING CH1, LAWSUIT L1
	WHERE CH1.CodLawsuit = L1.CodLawsuit 
	GROUP BY L1.SSN, CH1.CodLawsuit
	HAVING COUNT(*)>=1)
GROUP BY CH.CodLawsuit;

-- c. Show name, surname and birthdate of each judge who has presided over court hearings in every
-- court, in which (i.e. in each of which) at least 50 divorce lawsuits (LawsuitType = ‘Divorce’).
-- have been discussed.
SELECT Name, Surname, Birthdate
FROM JUDGE J, COURT_HEARING CH, LAWSUIT L
WHERE J.SSN=L.SSN AND L.CodLawsuit = CH.CodLawsuit AND CH.CodCourt IN (SELECT CH3.CodCourt
																																				FROM LAWSUIT L3, COURT_HEARING CH3 
																																				WHERE L3.CodLawsuit = CH3.CodLawsuit AND L3.LawsuitType = "Divorce"
																																				GROUP BY  CH3.CodCourt
																																				HAVING COUNT(DISTINCT CH3.CodLawsuit)>=2)											
GROUP BY  J.SSN, Name, Surname, Birthdate
HAVING COUNT(DISTINCT CH.CodLawsuit)= (SELECT COUNT(CR.CodCourt)
																				FROM COURTROOM CR
																				WHERE CR.CodCourt IN (SELECT CH2.CodCourt
																																	  FROM LAWSUIT L2, COURT_HEARING CH2 
																																	  WHERE L2.CodLawsuit = CH2.CodLawsuit AND L2.LawsuitType = "Divorce"
																																	  GROUP BY  CH2.CodCourt
																																	  HAVING COUNT(DISTINCT CH2.CodLawsuit)>=2));

CREATE TABLE TRAINER (SSN CHAR(5), NameT CHAR(10), Surname CHAR(10), City CHAR(10));
CREATE TABLE GYM (CodG CHAR(5), NameG CHAR(10), Address CHAR(20), City CHAR(10));
CREATE TABLE SPECIALITY (CodS CHAR(5), NameSp CHAR(10), Description CHAR(15));
CREATE TABLE LESSON (SSN CHAR(5), CodG CHAR(5), Sana DATE, CodS CHAR(5), ParticipantsNumber CHAR(5));


INSERT INTO TRAINER VALUES("TT1", "Giovanni", "Francesco", "Turin");
INSERT INTO TRAINER VALUES("TT2", "Asadbek", "Iskandarov", "Andijan");
INSERT INTO TRAINER VALUES("TT3", "Sortino", "Vinardi", "Turin");
INSERT INTO TRAINER VALUES("TT4", "Nouman", "Ali Khan", "Texas");
INSERT INTO TRAINER VALUES("TT5", "Omar", "Suleiman", "Texas");

INSERT INTO GYM VALUES("GG1", "Pride", "Via Torricelli", "Milan");
INSERT INTO GYM VALUES("GG2", "McFit", "Via Bobbio", "Turin");
INSERT INTO GYM VALUES("GG3", "Bull", "Corso Rosselli", "Turin");
INSERT INTO GYM VALUES("GG4", "Pride", "Via Torricelli", "Turin");
INSERT INTO GYM VALUES("GG5", "McFit", "Via Tripoli", "Milan");
INSERT INTO GYM VALUES("GG6", "Smart", "Corso Leone", "Turin");

INSERT INTO SPECIALITY VALUES("SS1", "Soccer", "Inside");
INSERT INTO SPECIALITY VALUES("SS2", "Judo", "Inside");
INSERT INTO SPECIALITY VALUES("SS3", "Yoga", "Inside");
INSERT INTO SPECIALITY VALUES("SS4", "Basketball", "Inside");
INSERT INTO SPECIALITY VALUES("SS5", "Vollleyball", "Inside");

INSERT INTO LESSON VALUES("TT1", "GG1", '2021-11-10', "SS1", "001");
INSERT INTO LESSON VALUES("TT2", "GG3", '2021-05-10', "SS2", "011");
INSERT INTO LESSON VALUES("TT2", "GG2", '2022-11-10', "SS3", "009");
INSERT INTO LESSON VALUES("TT4", "GG1", '2019-11-10', "SS2", "009");
INSERT INTO LESSON VALUES("TT2", "GG4", '2020-11-10', "SS3", "011");
INSERT INTO LESSON VALUES("TT4", "GG3", '2020-07-10', "SS2", "011");
INSERT INTO LESSON VALUES("TT2", "GG6", '2020-11-10', "SS3", "001");


-- a. For each gym in Turin in which Judo lessons (NameS="Judo") have been given by at least 5
-- different trainers, but no yoga lessons have ever been given (NameS="Yoga"), show the name of the
-- gym and the number of different trainers who have given lessons (considering each specialty, not
-- judo only) there.


SELECT NameG, COUNT(DISTINCT L.SSN)
FROM TRAINER T, LESSON L, GYM G
WHERE T.SSN = L.SSN AND L.CodG= G.CodG AND G.City = "Turin" AND L.CodG IN (SELECT L1.CodG
	FROM SPECIALITY S, LESSON L1
	WHERE S.CodS = L1.CodS AND NameSp = "Judo"
	GROUP BY L1.CodG, L1.CodS
	HAVING COUNT(DISTINCT L1.SSN)>=2)
AND L.CodG NOT IN (SELECT L2.CodG
	FROM SPECIALITY S1, LESSON L2
	WHERE S1.CodS = L2.CodS AND NameSp ="Yoga")
GROUP BY L.CodG;

-- b. For each trainer who has given only Yoga lessons, show the name, the surname, and the city of the
-- gym where he has given the highest number of lessons.

SELECT NameT, Surname, G.City
FROM TRAINER T, GYM G, LESSON L
WHERE L.SSN = T.SSN AND G.CodG = L.CodG AND L.CodG NOT IN (SELECT L1.CodG
	FROM SPECIALITY S1, LESSON L1
	WHERE S1.CodS = L1.CodS AND NameSp !="Yoga")
GROUP BY L.CodG, L.SSN 
HAVING COUNT(*) =
	(SELECT MAX(Numless) 
		FROM LESSON L3, (SELECT COUNT(*) AS Numless, L4.CodG, L4.SSN
										 FROM LESSON L4
										 GROUP BY L4.CodG, L4.SSN) AS Nums 
	  WHERE L3.SSN = Nums.SSN );
-- c. For each trainer who has trained in every gym in his city of residence, show name, surname, and
-- number of specialties for which he has given lessons.

SELECT NameT, Surname, COUNT(DISTINCT L.CodS)
FROM TRAINER T, LESSON L 
WHERE T.SSN= L.SSN AND L.SSN IN (SELECT L1.SSN 
	FROM LESSON L1, GYM G, TRAINER T1
	WHERE L1.SSN = T1.SSN AND G.CodG = L1.CodG AND T1.City = G.City 
	GROUP BY L1.SSN, T1.City 
	HAVING COUNT(DISTINCT L1.CodG)= (SELECT COUNT(*)
	                  FROM GYM G1
									  WHERE G1.City = T1.City
	                  GROUP BY G1.City ))
GROUP BY L.SSN 
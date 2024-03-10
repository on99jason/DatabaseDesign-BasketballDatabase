DROP TABLE Trade;
DROP TABLE Substitute; 
DROP TABLE Starter;
DROP TABLE box_score; 
DROP TABLE Game; 
DROP TABLE Arena; 
DROP TABLE Player;
DROP TABLE G_league;
DROP TABLE NCAA; 
DROP TABLE NBA;
DROP TABLE Team;

CREATE TABLE Team(
team_id   DECIMAL(12) PRIMARY KEY,
team_name VARCHAR(30) NOT NULL,
city      VARCHAR(30) NOT NULL,
league_id DECIMAL(12));

CREATE TABLE NBA(
team_id    DECIMAL(12) PRIMARY KEY,
FOREIGN KEY (team_id) REFERENCES Team(team_id),
division   VARCHAR(30) NOT NULL,
conference VARCHAR(30) NOT NULL); 

CREATE TABLE NCAA(
team_id    DECIMAL(12) PRIMARY KEY,
FOREIGN KEY (team_id) REFERENCES Team(team_id),
division   VARCHAR(30) NOT NULL,
conference VARCHAR(30) NOT NULL,
university VARCHAR(50) NOT NULL); 

CREATE TABLE G_League(
team_id        DECIMAL(12) PRIMARY KEY,
FOREIGN KEY (team_id) REFERENCES Team(team_id),
conference     VARCHAR(30) NOT NULL,
affiliated_nba VARCHAR(50)); 

CREATE TABLE Player(
player_id DECIMAL(12) PRIMARY KEY,
current_team_id DECIMAL(12),
FOREIGN KEY (current_team_id) REFERENCES team(team_id),
first_name    VARCHAR(20) NOT NULL,
last_name     VARCHAR(20) NOT NULL,
birthdate     DATE        NOT NULL, 
status        VARCHAR(10) NOT NULL CHECK (status IN ('Healthy', 'Day-To-Day', 'Out')),
position      VARCHAR(15) NOT NULL CHECK (position IN('Point Guard', 'Shooting Guard', 'Small Forward', 'Power Forward', 'Center')),
draft_info    VARCHAR(23) NOT NULL, 
height_weight VARCHAR(16) NOT NULL);

CREATE TABLE Arena(
arena_id   DECIMAL(12) PRIMARY KEY,
arena_name VARCHAR(50) NOT NULL,
address    VARCHAR(100) NOT NULL,
city       VARCHAR(50) NOT NULL);

CREATE TABLE Game(
game_id      DECIMAL(12) PRIMARY KEY, 
season_id    DECIMAL(12) NOT NULL, 
home_team_id DECIMAL(12) NOT NULL,
home_team_pt DECIMAL(3) NOT NULL,
away_team_id DECIMAL(12) NOT NULL,
away_team_pt DECIMAL(3) NOT NULL,
arena_id     DECIMAL(12) NOT NULL,
home_pog     DECIMAL(12) NOT NULL, 
away_pog     DECIMAL(12) NOT NULL,
game_date DATE NOT NULL,
FOREIGN KEY (home_team_id) REFERENCES Team(team_id),
FOREIGN KEY (away_team_id) REFERENCES Team(team_id),
FOREIGN KEY (home_pog) REFERENCES Player(player_id),
FOREIGN KEY (away_pog) REFERENCES Player(player_id),
FOREIGN KEY (arena_id) REFERENCES Arena(arena_id)); 

CREATE TABLE Box_Score(
game_id         DECIMAL(12), 
player_id       DECIMAL(12),
starter         VARCHAR(3) NOT NULL CHECK (starter IN('Yes', 'No')),
minutes         DECIMAL(3), 
shot_made       DECIMAL(3),
shot_attempted  DECIMAL(3),
three_made      DECIMAL(3),
three_attempted DECIMAL(3),
ft_made         DECIMAL(3),
ft_attempted    DECIMAL(3),
o_rebound       DECIMAL(3),
d_rebound       DECIMAL(3),
assist          DECIMAL(3),
block           DECIMAL(3),
steal           DECIMAL(3),
personal_foul   DECIMAL(3),
turnover        DECIMAL(3),
point_score     DECIMAL(3),
plus_minus      DECIMAL(3),
CONSTRAINT bs_pk PRIMARY KEY(game_id, player_id), 
FOREIGN KEY (game_id) REFERENCES Game(game_id),
FOREIGN KEY (player_id) REFERENCES Player(player_id)); 

CREATE TABLE Starter(
game_id   DECIMAL(12), 
player_id DECIMAL(12),
CONSTRAINT starter_pk PRIMARY KEY(game_id, player_id), 
FOREIGN KEY (game_id) REFERENCES Game(game_id),
FOREIGN KEY (player_id) REFERENCES Player(player_id)); 

CREATE TABLE Substitute(
game_id   DECIMAL(12), 
player_id DECIMAL(12),
CONSTRAINT sub_pk PRIMARY KEY(game_id, player_id), 
FOREIGN KEY (game_id) REFERENCES Game(game_id),
FOREIGN KEY (player_id) REFERENCES Player(player_id)); 




--BasketballStats Transaction (Stored Procedures for Inserting Data)

--Team Record Use Case 
CREATE OR REPLACE PROCEDURE addNBAteam (TEAM_ID IN DECIMAL, TEAM_NAME IN VARCHAR, CITY IN VARCHAR, 
    DIVISION IN VARCHAR, CONFERENCE IN VARCHAR)
AS 
BEGIN
    INSERT INTO Team(TEAM_ID, TEAM_NAME, CITY, LEAGUE_ID)
    VALUES(TEAM_ID, TEAM_NAME, CITY, 1);
    
    INSERT INTO NBA(TEAM_ID, DIVISION, CONFERENCE)
    VALUES(TEAM_ID, DIVISION, CONFERENCE);
END;
/
BEGIN
    addNBAteam(1, 'Celtics', 'Boston', 'Atlantic', 'Eastern');
    addNBAteam(2, '76ers', 'Philadelphia', 'Atlantic', 'Eastern');
    addNBAteam(3, 'Warriors', 'Golden State', 'Pacific', 'Western');
    addNBAteam(4, 'Lakers', 'Los Angeles', 'Pacific', 'Western');
    COMMIT;
END;
/


--Player Profile Use Case
CREATE OR REPLACE PROCEDURE addplayer(PLAYER_ID IN DECIMAL, CURRENT_TEAM_ID IN DECIMAL, 
    FIRST_NAME IN VARCHAR, LAST_NAME IN VARCHAR, BIRTHDATE IN DATE, STATUS IN VARCHAR, 
    POSITION IN VARCHAR, DRAFT_INFO IN VARCHAR, HEIGHT_WEIGHT IN VARCHAR)
AS 
BEGIN 
    INSERT INTO Player(PLAYER_ID, CURRENT_TEAM_ID, FIRST_NAME, LAST_NAME, BIRTHDATE, STATUS, POSITION, DRAFT_INFO, HEIGHT_WEIGHT)
    VALUES (PLAYER_ID, CURRENT_TEAM_ID, FIRST_NAME, LAST_NAME, BIRTHDATE, STATUS, POSITION, DRAFT_INFO, HEIGHT_WEIGHT);
END; 
/
BEGIN
    addplayer(1, 1, 'Jayson', 'Tatum', CAST('03-MAR-1998' AS DATE), 'Healthy', 'Small Forward', 
    '2017: Rd 1, Pk 3 (BOS)', '6'' 8'''', 210 lbs');
    addplayer(2, 2, 'James', 'Harden', CAST('26-AUG-1989' AS DATE), 'Healthy', 'Shooting Guard', 
    '2009: Rd 1, Pk 3 (OKC)', '6'' 5'''', 220 lbs');
    addplayer(3, 1, 'Jaylen', 'Brown', CAST('24-OCT-1996' AS DATE), 'Healthy', 'Shooting Guard', 
    '2016: Rd 1, Pk 3 (BOS)', '6'' 6'''', 223 lbs');
    addplayer(4, 1, 'Al', 'Horford', CAST('03-JUN-1986' AS DATE), 'Healthy', 'Center', 
    '2007: Rd 1, Pk 3 (ATL)', '6'' 9'''', 240 lbs');
    addplayer(5, 1, 'Derrick', 'White', CAST('02-JUL-1994' AS DATE), 'Healthy', 'Point Guard', 
    '2017: Rd 1, Pk 29 (SA)', '6'' 4'''', 190 lbs');
    addplayer(6, 1, 'Marcus', 'Smart', CAST('06-MAR-1994' AS DATE), 'Healthy', 'Point Guard', 
    '2014: Rd 1, Pk 6 (BOS)', '6'' 4'''', 220 lbs');
    addplayer(7, 2, 'Joel', 'Embiid', CAST('16-MAR-1994' AS DATE), 'Healthy', 'Center', 
    '2014: Rd 1, Pk 3 (PHI)', '7'' 0'''', 280 lbs');
    addplayer(8, 2, 'P.J.', 'Tucker', CAST('05-MAY-1985' AS DATE), 'Healthy', 'Power Forward', 
    '2006: Rd 2, Pk 35 (TOR)', '6'' 5'''', 245 lbs');
    addplayer(9, 2, 'Tobias', 'Harris', CAST('15-JUL-1992' AS DATE), 'Healthy', 'Power Forward', 
    '2011: Rd 1, Pk 19 (CHA)', '6'' 7'''', 226 lbs');
    addplayer(10, 2, 'Tyrese', 'Maxey', CAST('04-NOV-2000' AS DATE), 'Healthy', 'Point Guard', 
    '2020: Rd 1, Pk 21 (PHI)', '6'' 2'''', 200 lbs');
    COMMIT;
END;
/


--GAME RESULT USE CASE
--Before running the following stored procedure: 
INSERT INTO arena VALUES (1, 'TD Garden', '100 Legends Way', 'Boston');  
INSERT INTO ARENA VALUES (2, 'Wells Fargo Center', '3601 S Broad St', 'Philadelphia');

CREATE OR REPLACE PROCEDURE AddGame (game_id IN DECIMAL, season_id IN DECIMAL, home_team_id IN DECIMAL, HOME_TEAM_PT IN DECIMAL, 
away_team_id IN DECIMAL, AWAY_TEAM_PT IN DECIMAL, arena_id IN DECIMAL, home_pog IN DECIMAL, away_pog IN DECIMAL) 
AS 
BEGIN 
    INSERT INTO Game
    VALUES(GAME_ID , SEASON_ID, HOME_TEAM_ID, HOME_TEAM_PT, AWAY_TEAM_ID, AWAY_TEAM_PT, ARENA_ID, HOME_POG, AWAY_POG, TRUNC(sysdate));
END; 
/

BEGIN 
    addgame(1, 77, 1, 126, 2, 117, 1, 1, 2);
    addgame(2, 77, 1, 106, 2, 99, 1, 5, 7);
    addgame(3, 77, 2, 107, 1, 110, 2, 7, 3);
    addgame(4, 77, 2, 103, 1, 101, 2, 7, 5);
    addgame(5, 77, 1, 115, 2, 119, 1, 1, 2);
    addgame(6, 77, 1, 121, 2, 87, 1, 3, 9);
    addgame(7, 77, 2, 102, 1, 114, 2, 7, 1);
    addgame(8, 77, 2, 116, 1, 115, 2, 2, 1);
    addgame(9, 77, 1, 103, 2, 115, 1, 1, 7);
    addgame(10, 77, 2, 86, 1, 95, 2, 7, 6);
    addgame(11, 77, 1, 112, 2, 88, 1, 1, 9);
    COMMIT;
END;
/


--BasketballStats History (Trade History Trigger)
CREATE TABLE Trade(
trade_id DECIMAL(12) PRIMARY KEY, 
player_id DECIMAL(12) NOT NULL,
old_team_id DECIMAL(12),
new_team_id DECIMAL(12), 
trade_date DATE NOT NULL,
FOREIGN KEY (player_id) REFERENCES Player(player_id)); 

--(Trade History Trigger)
CREATE OR REPLACE TRIGGER trade_trg
BEFORE UPDATE OF CURRENT_TEAM_ID ON Player 
FOR EACH ROW
BEGIN 
    INSERT INTO Trade VALUES (NVL((SELECT MAX(trade_id)+1 FROM Trade), 1),
                                :New.player_id, 
                                :OLD.current_team_id, 
                                :NEW.current_team_id, 
                                TRUNC(sysdate));
END; 
/

SELECT * FROM PLAYER;

UPDATE Player SET current_team_id = 4 WHERE player_id = 2;
UPDATE Player SET current_team_id = 2 WHERE player_id = 2;

SELECT * FROM TRADE;




--BasketballStats Question and Query 
--BOS avg points
SELECT w_team, AVG(w_score)
FROM(
    SELECT game_id, home.city||' '||home.team_name AS W_team, home_team_pt AS w_score
    FROM game
    JOIN team home ON game.home_team_id = home.team_id
    WHERE home.city = 'Boston' AND home_team_pt > away_team_pt
    UNION ALL
    SELECT game_id, away.city||' '||away.team_name AS W_team, away_team_pt AS w_score
    FROM game
    JOIN team away ON game.away_team_id = away.team_id
    WHERE away.city = 'Boston' AND home_team_pt < away_team_pt
    ORDER BY game_id)
GROUP BY w_team;

--Most POG
SELECT player, COUNT(player) AS pog_times 
FROM (
    SELECT home_pog AS id, h.first_name||' '||h.last_name as player
    FROM game
    JOIN player h ON game.home_pog = h.player_id
    UNION ALL
    SELECT away_pog AS id, a.first_name||' '||a.last_name as player
    FROM game
    JOIN player a ON game.away_pog = a.player_id)
GROUP BY player
ORDER BY -pog_times;

--Most Trade
BEGIN
    addNBAteam(5, 'Grizzlies', 'Memphis', 'Southwest', 'Western');
    addNBAteam(6, 'Mavericks', 'Dallas', 'Southwest', 'Western');
    addNBAteam(7, 'Wizards', 'Washington', 'Southeast', 'Eastern');
    COMMIT;
END;
/

BEGIN
    addplayer(11, 1, 'Grant', 'Williams', CAST('30-NOV-1996' AS DATE), 'Day-To-Day', 'Power Forward', 
    '2019: Rd 1, Pk 22 (BOS)', '6'' 6'''', 236 lbs');
    addplayer(12, 7, 'Kristaps', 'Porzingis', CAST('02-AUG-1995' AS DATE), 'Healthy', 'Center', 
    '2015: Rd 1, Pk 4 (NY)', '7'' 3'''', 240 lbs');
    COMMIT;
END;
/

UPDATE Player SET current_team_id = 5 WHERE player_id = 6;
UPDATE Player SET current_team_id = 1 WHERE player_id = 12;
UPDATE Player SET current_team_id = 6 WHERE player_id = 11;

SELECT first_name||' ' ||last_name AS player, 
    old_team.city||' '||old_team.team_name AS old_team, 
    new_team.city||' '||new_team.team_name AS new_team,
    trade_date
FROM trade
JOIN player ON trade.player_id = player.player_id
JOIN team old_team ON old_team.team_id = trade.old_team_id
JOIN team new_team ON new_team.team_id = trade.new_team_id
WHERE trade_date > add_months(SYSDATE,-3) AND (old_team_id =1 OR new_team_id =1);
-- =============================================
--   SPORTS CLUB MANAGEMENT SYSTEM - DATABASE
-- =============================================

CREATE DATABASE IF NOT EXISTS sports_club_db;
use sports_club_db;

-- ============ CRICKET CLUBS ============
CREATE TABLE IF NOT EXISTS players_mi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    type VARCHAR(50),
    coach VARCHAR(100),
    expiry DATE check (expiry > curdate()),
    fees INT
);
select * from players_mi;
insert into players_mi values(101,'siddhant',22,'boller','mahilia javardhan','2012-12-12',2000);
delete from players_mi where id = 101;

CREATE TABLE IF NOT EXISTS players_csk (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    type VARCHAR(50) ,
    coach VARCHAR(100),
    expiry DATE check (expiry > curdate()),
    fees INT
);

CREATE TABLE IF NOT EXISTS players_rr (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    type VARCHAR(50) ,
    coach VARCHAR(100),
    expiry DATE check (expiry > curdate()),
    fees INT
);

-- ============ FOOTBALL CLUBS ============
CREATE TABLE IF NOT EXISTS players_fcb (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    type VARCHAR(50) ,
    coach VARCHAR(100),
    expiry DATE check (expiry > curdate()),
    fees INT
);

CREATE TABLE IF NOT EXISTS players_rma (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    type VARCHAR(50),
    coach VARCHAR(100),
    expiry DATE check (expiry > curdate()),
    fees INT
);

CREATE TABLE IF NOT EXISTS players_psg (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    type VARCHAR(50),
    coach VARCHAR(100),
    expiry DATE check (expiry > curdate()),
    fees INT
);

-- ============ KABADDI CLUBS ============
CREATE TABLE IF NOT EXISTS players_up (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    type VARCHAR(50),
    coach VARCHAR(100),
    expiry DATE check (expiry > curdate()),
    fees INT
);

CREATE TABLE IF NOT EXISTS players_jaipur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL ,
    type VARCHAR(50),
    coach VARCHAR(100),
    expiry DATE check (expiry > curdate()),
    fees INT
);

CREATE TABLE IF NOT EXISTS players_patna (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    type VARCHAR(50),
    coach VARCHAR(100),
    expiry DATE check (expiry > curdate()),
    fees INT
);

-- drop table on_delete;
create table on_delete(
 id INT ,
    name VARCHAR(100),
    age INT NOT NULL,
    type VARCHAR(50),
    coach VARCHAR(100),
    expiry DATE,
    fees INT,
    club varchar(50),
    log_timestamp timestamp default current_timestamp);
   
   
-- select * from on_delete;

create table player_login(
    id int primary key auto_increment,
    username varchar(50) not null,
    password varchar(100) not null,
    player_id int not null,
    club varchar(20) not null
);

delimiter **
create trigger on_player_login_mi
after insert on players_mi
for each row
begin
	insert into player_login(username,password,player_id,club)
    values(new.username,concat(new.username + new.player_id),new.club,'MI');
end
**
delimiter ;


-- ===================================================================
-- ======================Trigers======================================
-- ==================================================================

delimiter **
create trigger on_delete_mi
before delete on players_mi
for each row
begin
	insert into on_delete(id,name,age,type,coach,expiry,fees,club)
    values(old.id,old.name,old.age,old.type,old.coach,old.expiry,old.fees,'MI');
end
**
delimiter ;
select * from on_delete;

delimiter **
create trigger on_delete_csk
before delete on players_csk
for each row
begin
	insert into on_delete(id,name,age,type,coach,expiry,fees,club)
    values(old.id,old.name,old.age,old.type,old.coach,old.expiry,old.fees,'players_csk');
end
**
delimiter ;

delimiter **
create trigger on_delete_rr
before delete on players_rr
for each row
begin
	insert into on_delete(id,name,age,type,coach,expiry,fees,club)
    values(old.id,old.name,old.age,old.type,old.coach,old.expiry,old.fees,'players_rr');
end
**
delimiter ;


delimiter **
create trigger on_delete_fcb
before delete on players_fcb
for each row
begin
	insert into on_delete(id,name,age,type,coach,expiry,fees,club)
    values(old.id,old.name,old.age,old.type,old.coach,old.expiry,old.fees,'players_fcb');
end
**
delimiter ;

delimiter **
create trigger on_delete_rma
before delete on players_rma
for each row
begin
	insert into on_delete(id,name,age,type,coach,expiry,fees,club)
    values(old.id,old.name,old.age,old.type,old.coach,old.expiry,old.fees,'players_rma');
end
**
delimiter ;

delimiter **
create trigger on_delete_psg
before delete on players_psg
for each row
begin
	insert into on_delete(id,name,age,type,coach,expiry,fees,club)
    values(old.id,old.name,old.age,old.type,old.coach,old.expiry,old.fees,'players_psg');
end
**
delimiter ;

delimiter **
create trigger on_delete_up
before delete on players_up
for each row
begin
	insert into on_delete(id,name,age,type,coach,expiry,fees,club)
    values(old.id,old.name,old.age,old.type,old.coach,old.expiry,old.fees,'players_up');
end
**
delimiter ;

delimiter **
create trigger on_delete_jaipur
before delete on players_jaipur
for each row
begin
	insert into on_delete(id,name,age,type,coach,expiry,fees,club)
    values(old.id,old.name,old.age,old.type,old.coach,old.expiry,old.fees,'players_jaipur');
end
**
delimiter ;

delimiter **
create trigger on_delete_patna
before delete on players_patna
for each row
begin
	insert into on_delete(id,name,age,type,coach,expiry,fees,club)
    values(old.id,old.name,old.age,old.type,old.coach,old.expiry,old.fees,'players_patna');
end
**
delimiter ;

-- ==================================================================================================================================================
-- -------------------------                                       ---------------------------
-- ===================================================================================================================================================

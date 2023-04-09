-- Shows Available Databases --
SHOW DATABASES;

-- Create Database --
CREATE DATABASE mahasiswa_52419251;

-- Using Database mahasiswa_52419251 --
USE mahasiswa_52419251;

-- Creating Table mhs --
CREATE TABLE mhs (Nama VARCHAR(20), Kelas VARCHAR(5), 
Alamat VARCHAR(20));

-- Show Available Table In Database (mahasiswa_52419251) --
SHOW TABLES;

-- Show Table Schema mhs --
DESC mhs;

-- Change field Nama to Name and length string in Name --
ALTER TABLE mhs CHANGE Nama Name VARCHAR(28);

-- Add Field NPM in First Position--
ALTER TABLE mhs ADD NPM VARCHAR(8) first;

-- Alter table add primary key to field NPM --
ALTER TABLE mhs ADD PRIMARY KEY (NPM);

-- Change length string on field Alamat --
ALTER TABLE mhs MODIFY Alamat VARCHAR(30);


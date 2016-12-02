-- Generated by Oracle SQL Developer Data Modeler 4.1.5.907
--   at:        2016-12-02 14:15:09 EST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g




CREATE TABLE Addresse
  (
    NoCivique  INTEGER NOT NULL ,
    Rue        VARCHAR2 (256) NOT NULL ,
    CodePostal VARCHAR2 (6) NOT NULL ,
    Ville      VARCHAR2 (20) NOT NULL ,
    Province   VARCHAR2 (40) NOT NULL ,
    NoAddresse INTEGER NOT NULL
  ) ;
ALTER TABLE Addresse ADD CONSTRAINT Locations_PK PRIMARY KEY ( NoAddresse ) ;


CREATE TABLE Categorie
  (
    Nom         VARCHAR2 (50) NOT NULL ,
    NoCategorie INTEGER NOT NULL ,
    Parent      INTEGER
  ) ;
ALTER TABLE Categorie ADD CONSTRAINT Categorie_PK PRIMARY KEY ( NoCategorie ) ;


CREATE TABLE Client
  (
    NomUtilisateur VARCHAR2 (20) NOT NULL ,
    MotDePasse     VARCHAR2 (20) NOT NULL ,
    Nom            VARCHAR2 (20) ,
    Prenom         VARCHAR2 (20) ,
    NoClient       INTEGER NOT NULL ,
    NoAddresse     INTEGER ,
    Courriel       VARCHAR2 (256) NOT NULL ,
    NumTel         VARCHAR2 (31)
  ) ;
ALTER TABLE Client ADD CONSTRAINT Clients_PK PRIMARY KEY ( NoClient ) ;


CREATE TABLE Coupon
  (
    CodeCoupon  INTEGER NOT NULL ,
    Rabais      NUMBER (3,2) NOT NULL ,
    Expiration  DATE ,
    Description VARCHAR2 (10)
  ) ;
ALTER TABLE Coupon ADD CONSTRAINT Coupon_Rabais_Positif CHECK (Rabais  > 0) ;
ALTER TABLE Coupon ADD CONSTRAINT Coupon_Rabais_Pourcent CHECK (Rabais < 1) ;
ALTER TABLE Coupon ADD CONSTRAINT Coupon_PK PRIMARY KEY ( CodeCoupon ) ;


CREATE TABLE Emplacement
  (
    NoEmplacement INTEGER NOT NULL ,
    Nom           VARCHAR2 (50) ,
    SiteWeb       VARCHAR2 (256) ,
    Capacite      INTEGER ,
    Courriel      VARCHAR2 (256) ,
    NoAddresse    INTEGER NOT NULL ,
    NumTel        VARCHAR2 (31)
  ) ;
CREATE UNIQUE INDEX Emplacement__IDX ON Emplacement
  (
    NoAddresse ASC
  )
  ;
ALTER TABLE Emplacement ADD CONSTRAINT Emplacement_PK PRIMARY KEY ( NoEmplacement ) ;


CREATE TABLE Evenement
  (
    NoEvenement INTEGER NOT NULL ,
    Titre       VARCHAR2 (50) NOT NULL ,
    Description VARCHAR2 (512) ,
    SiteWeb     VARCHAR2 (256) ,
    Duree INTERVAL DAY (9) TO SECOND (0) NOT NULL ,
    ImageAffiche BLOB ,
    NoCategorie INTEGER
  ) ;
CREATE UNIQUE INDEX Evenement__IDX ON Evenement
  (
    NoCategorie ASC
  )
  ;
ALTER TABLE Evenement ADD CONSTRAINT Evenement_PK PRIMARY KEY ( NoEvenement ) ;


CREATE TABLE Occurence
  (
    NoOccurence   INTEGER NOT NULL ,
    DateEtHeure   TIMESTAMP ,
    Prix          NUMBER (10,2) ,
    NoEvenement   INTEGER NOT NULL ,
    NoEmplacement INTEGER NOT NULL
  ) ;
ALTER TABLE Occurence ADD CONSTRAINT Occurence_Prix_Positif CHECK (Prix > 0) ;
ALTER TABLE Occurence ADD CONSTRAINT Occurence_PK PRIMARY KEY ( NoOccurence ) ;


CREATE TABLE Transaction
  (
    NoTransaction INTEGER NOT NULL ,
    Statut        VARCHAR2 (12) DEFAULT 'en attente' NOT NULL ,
    Cout          NUMBER NOT NULL ,
    "Date"        TIMESTAMP NOT NULL ,
    ModePaiement  VARCHAR2 (8 CHAR) NOT NULL ,
    MontantPaye   NUMBER NOT NULL ,
    Billets       INTEGER NOT NULL ,
    NoClient      INTEGER NOT NULL ,
    NoOccurence   INTEGER NOT NULL ,
    CodeCoupon    INTEGER
  ) ;
ALTER TABLE Transaction ADD CHECK ( Statut       IN ('annulée', 'approuvée', 'en attente', 'payée')) ;
ALTER TABLE Transaction ADD CHECK ( ModePaiement IN ('comptant', 'credit', 'debit')) ;
ALTER TABLE Transaction ADD CONSTRAINT Transaction_PK PRIMARY KEY ( NoTransaction ) ;


ALTER TABLE Client ADD CONSTRAINT ClientAddresse FOREIGN KEY ( NoAddresse ) REFERENCES Addresse ( NoAddresse ) ;

ALTER TABLE Transaction ADD CONSTRAINT ClientTransactions FOREIGN KEY ( NoClient ) REFERENCES Client ( NoClient ) ;

ALTER TABLE Transaction ADD CONSTRAINT CouponTransactions FOREIGN KEY ( CodeCoupon ) REFERENCES Coupon ( CodeCoupon ) ;

ALTER TABLE Emplacement ADD CONSTRAINT EmplacementAddresse FOREIGN KEY ( NoAddresse ) REFERENCES Addresse ( NoAddresse ) ;

ALTER TABLE Evenement ADD CONSTRAINT EvenementCategorie FOREIGN KEY ( NoCategorie ) REFERENCES Categorie ( NoCategorie ) ;

ALTER TABLE Occurence ADD CONSTRAINT EvenementOccurence FOREIGN KEY ( NoEvenement ) REFERENCES Evenement ( NoEvenement ) ON
DELETE CASCADE ;

ALTER TABLE Occurence ADD CONSTRAINT OccurenceEmplacement FOREIGN KEY ( NoEmplacement ) REFERENCES Emplacement ( NoEmplacement ) ;

ALTER TABLE Transaction ADD CONSTRAINT OccurenceTransactions FOREIGN KEY ( NoOccurence ) REFERENCES Occurence ( NoOccurence ) ;

ALTER TABLE Categorie ADD CONSTRAINT souscat FOREIGN KEY ( Parent ) REFERENCES Categorie ( NoCategorie ) ;

CREATE OR REPLACE TRIGGER FKNTM_Occurence BEFORE
  UPDATE OF NoEvenement ON Occurence BEGIN raise_application_error(-20225,'Non Transferable FK constraint  on table Occurence is violated');
END;
/

CREATE OR REPLACE TRIGGER FKNTO_Transaction BEFORE
  UPDATE OF CodeCoupon ON Transaction FOR EACH ROW BEGIN IF :old.CodeCoupon IS NOT NULL THEN raise_application_error(-20225,'Non Transferable FK constraint CouponTransactions on table Transaction is violated');
END IF;
END;
/
CREATE OR REPLACE TRIGGER FKNTM_Transaction BEFORE
  UPDATE OF NoClient,
    NoOccurence ON Transaction BEGIN raise_application_error(-20225,'Non Transferable FK constraint  on table Transaction is violated');
END;
/


-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             8
-- CREATE INDEX                             2
-- ALTER TABLE                             22
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           3
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

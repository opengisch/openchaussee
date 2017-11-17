--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.4
-- Dumped by pg_dump version 9.4.0
-- Started on 2017-11-17 15:38:38

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 9 (class 2615 OID 305423937)
-- Name: chaussee_dev; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA chaussee_dev;


SET search_path = chaussee_dev, pg_catalog;

--
-- TOC entry 1373 (class 1255 OID 315022459)
-- Name: timestamp_fct(); Type: FUNCTION; Schema: chaussee_dev; Owner: -
--

CREATE FUNCTION timestamp_fct() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  NEW.cgm_updatedate = now();
  RETURN NEW;
END$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 296 (class 1259 OID 315105537)
-- Name: t_axissegments; Type: TABLE; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE TABLE t_axissegments (
    asg_iliid text NOT NULL,
    asg_axe_iliid text,
    asg_capturemethod_cat_iliid text,
    asg_capturedate date,
    asg_accuracyhorizontal real,
    asg_accuracyvertical real,
    asg_name character varying(64),
    asg_sequence smallint,
    asg_importdate date,
    asg_geom public.geometry,
    CONSTRAINT enforce_dims_asg_geom CHECK ((public.st_ndims(asg_geom) = 4)),
    CONSTRAINT enforce_geotype_asg_geom CHECK (((public.geometrytype(asg_geom) = 'MULTILINESTRING'::text) OR (asg_geom IS NULL))),
    CONSTRAINT enforce_srid_asg_geom CHECK ((public.st_srid(asg_geom) = 2056))
);


--
-- TOC entry 280 (class 1259 OID 305458061)
-- Name: t_current_geometries; Type: TABLE; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE TABLE t_current_geometries (
    cgm_iliid text NOT NULL,
    cgm_geom public.geometry(Polygon,2056),
    cgm_asg_iliid text,
    cgm_calcul_length numeric(10,2),
    cgm_calcul_area numeric(10,2),
    cgm_updatedate timestamp without time zone NOT NULL,
    cgm_updateuser character varying(36) NOT NULL,
    cgm_statut boolean DEFAULT true NOT NULL
);


--
-- TOC entry 3721 (class 0 OID 0)
-- Dependencies: 280
-- Name: TABLE t_current_geometries; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON TABLE t_current_geometries IS 'Géométrie de la chaussée';


--
-- TOC entry 3722 (class 0 OID 0)
-- Dependencies: 280
-- Name: COLUMN t_current_geometries.cgm_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries.cgm_iliid IS 'Identifiant interne';


--
-- TOC entry 3723 (class 0 OID 0)
-- Dependencies: 280
-- Name: COLUMN t_current_geometries.cgm_geom; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries.cgm_geom IS 'Polygones "libres", pas multipolygone, pas de trou.';


--
-- TOC entry 3724 (class 0 OID 0)
-- Dependencies: 280
-- Name: COLUMN t_current_geometries.cgm_asg_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries.cgm_asg_iliid IS 'Segment d''axe concerné';


--
-- TOC entry 3725 (class 0 OID 0)
-- Dependencies: 280
-- Name: COLUMN t_current_geometries.cgm_calcul_length; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries.cgm_calcul_length IS 'Longueur SRB de la couche (Calculé)';


--
-- TOC entry 3726 (class 0 OID 0)
-- Dependencies: 280
-- Name: COLUMN t_current_geometries.cgm_calcul_area; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries.cgm_calcul_area IS 'Surface SRB de la couche (Calculé)';


--
-- TOC entry 3727 (class 0 OID 0)
-- Dependencies: 280
-- Name: COLUMN t_current_geometries.cgm_updatedate; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries.cgm_updatedate IS 'Date de la mise à jour, la création est une mise à jour (système)';


--
-- TOC entry 3728 (class 0 OID 0)
-- Dependencies: 280
-- Name: COLUMN t_current_geometries.cgm_updateuser; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries.cgm_updateuser IS 'Auteur de la mise à jour (système)';


--
-- TOC entry 3729 (class 0 OID 0)
-- Dependencies: 280
-- Name: COLUMN t_current_geometries.cgm_statut; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries.cgm_statut IS 'Enregistrement actif/ inactif';


--
-- TOC entry 298 (class 1259 OID 315223579)
-- Name: t_current_geometries_v1; Type: TABLE; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE TABLE t_current_geometries_v1 (
    cgm_iliid text NOT NULL,
    cgm_asg_iliid text,
    cgm_calcul_length numeric(10,2),
    cgm_calcul_area numeric(10,2),
    cgm_start_date date,
    cgm_end_date date,
    cgm_createdate timestamp without time zone DEFAULT now(),
    cgm_updatedate timestamp without time zone DEFAULT now() NOT NULL,
    cgm_updateuser character varying(36) NOT NULL,
    cgm_statut boolean DEFAULT true NOT NULL,
    cgm_geom public.geometry(Polygon,2056),
    cgm_line_geom public.geometry(LineString,2056)
);


--
-- TOC entry 3730 (class 0 OID 0)
-- Dependencies: 298
-- Name: TABLE t_current_geometries_v1; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON TABLE t_current_geometries_v1 IS 'Géométrie de la chaussée';


--
-- TOC entry 3731 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN t_current_geometries_v1.cgm_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries_v1.cgm_iliid IS 'Identifiant interne';


--
-- TOC entry 3732 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN t_current_geometries_v1.cgm_asg_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries_v1.cgm_asg_iliid IS 'Référence point linéaire fin de la géométrie actuelle';


--
-- TOC entry 3733 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN t_current_geometries_v1.cgm_calcul_length; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries_v1.cgm_calcul_length IS 'Longueur SRB de la couche (Calculé)';


--
-- TOC entry 3734 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN t_current_geometries_v1.cgm_calcul_area; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries_v1.cgm_calcul_area IS 'Surface SRB de la couche (Calculé)';


--
-- TOC entry 3735 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN t_current_geometries_v1.cgm_start_date; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries_v1.cgm_start_date IS 'Date de début de validité de la géométrie actuelle';


--
-- TOC entry 3736 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN t_current_geometries_v1.cgm_end_date; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries_v1.cgm_end_date IS 'Date de fin de validité de la géométrie actuelle';


--
-- TOC entry 3737 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN t_current_geometries_v1.cgm_createdate; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries_v1.cgm_createdate IS 'Date de création de la géométrie actuelle (système)';


--
-- TOC entry 3738 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN t_current_geometries_v1.cgm_updatedate; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries_v1.cgm_updatedate IS 'Date de la mise à jour (système)';


--
-- TOC entry 3739 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN t_current_geometries_v1.cgm_updateuser; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries_v1.cgm_updateuser IS 'Auteur de la mise à jour (système)';


--
-- TOC entry 3740 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN t_current_geometries_v1.cgm_statut; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries_v1.cgm_statut IS 'Enregistrement actif/ inactif';


--
-- TOC entry 3741 (class 0 OID 0)
-- Dependencies: 298
-- Name: COLUMN t_current_geometries_v1.cgm_geom; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_geometries_v1.cgm_geom IS 'Polygones "libres", pas multipolygone, pas de trou.';


--
-- TOC entry 282 (class 1259 OID 306243170)
-- Name: t_current_views; Type: TABLE; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE TABLE t_current_views (
    cuv_iliid text NOT NULL,
    cuv_geom public.geometry(MultiPolygon,2056),
    cuv_start_sec_iliid text,
    cuv_start_u double precision,
    cuv_end_sec_iliid text,
    cuv_end_u double precision,
    cuv_lay_iliid text,
    cuv_posedate date,
    cuv_thickness real,
    cuv_depth real,
    cuv_pro_iliid text,
    cuv_pvl_iliid text,
    cuv_calcul_length numeric(10,2),
    cuv_calcul_area numeric(10,2),
    cuv_updatedate timestamp without time zone NOT NULL,
    cuv_updateuser character varying(36) NOT NULL,
    cuv_statut boolean DEFAULT true NOT NULL
);


--
-- TOC entry 3742 (class 0 OID 0)
-- Dependencies: 282
-- Name: TABLE t_current_views; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON TABLE t_current_views IS 'Découpage des couches de structure pour la vue actuelle';


--
-- TOC entry 3743 (class 0 OID 0)
-- Dependencies: 282
-- Name: COLUMN t_current_views.cuv_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_views.cuv_iliid IS 'Identifiant interne';


--
-- TOC entry 3744 (class 0 OID 0)
-- Dependencies: 282
-- Name: COLUMN t_current_views.cuv_geom; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_views.cuv_geom IS 'polygone avec trou';


--
-- TOC entry 3745 (class 0 OID 0)
-- Dependencies: 282
-- Name: COLUMN t_current_views.cuv_pvl_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_views.cuv_pvl_iliid IS 'Couche d''origine';


--
-- TOC entry 3746 (class 0 OID 0)
-- Dependencies: 282
-- Name: COLUMN t_current_views.cuv_calcul_length; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_views.cuv_calcul_length IS 'Longueur SRB de la couche (Calculé)';


--
-- TOC entry 3747 (class 0 OID 0)
-- Dependencies: 282
-- Name: COLUMN t_current_views.cuv_calcul_area; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_views.cuv_calcul_area IS 'Surface SRB de la couche (Calculé)';


--
-- TOC entry 3748 (class 0 OID 0)
-- Dependencies: 282
-- Name: COLUMN t_current_views.cuv_updatedate; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_views.cuv_updatedate IS 'Date de la mise à jour, la création est une mise à jour (système)';


--
-- TOC entry 3749 (class 0 OID 0)
-- Dependencies: 282
-- Name: COLUMN t_current_views.cuv_updateuser; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_views.cuv_updateuser IS 'Auteur de la mise à jour  (système)';


--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 282
-- Name: COLUMN t_current_views.cuv_statut; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_current_views.cuv_statut IS 'Enregistrement actif/ inactif';


--
-- TOC entry 268 (class 1259 OID 305423953)
-- Name: t_layers; Type: TABLE; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE TABLE t_layers (
    lay_iliid text NOT NULL,
    lay_shortname character varying(36),
    lay_name character varying(72),
    lay_layer character varying(128),
    lay_material character varying(128),
    lay_remark character varying(255),
    lay_updatedate timestamp without time zone NOT NULL,
    lay_updateuser character varying(36) NOT NULL,
    lay_statut boolean DEFAULT true NOT NULL
);


--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 268
-- Name: TABLE t_layers; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON TABLE t_layers IS 'Catalogue des types de couche';


--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 268
-- Name: COLUMN t_layers.lay_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_layers.lay_iliid IS 'Identifiant interne';


--
-- TOC entry 3753 (class 0 OID 0)
-- Dependencies: 268
-- Name: COLUMN t_layers.lay_shortname; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_layers.lay_shortname IS 'Abréviation. (AB6,''AC11L, HMTxxx,...) ';


--
-- TOC entry 3754 (class 0 OID 0)
-- Dependencies: 268
-- Name: COLUMN t_layers.lay_name; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_layers.lay_name IS 'Libellé selon cat MISTRA (ex : AC 8S, avec polymères, C. de roulement)';


--
-- TOC entry 3755 (class 0 OID 0)
-- Dependencies: 268
-- Name: COLUMN t_layers.lay_layer; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_layers.lay_layer IS 'Couche (ex : RO  Couche de roulement)';


--
-- TOC entry 3756 (class 0 OID 0)
-- Dependencies: 268
-- Name: COLUMN t_layers.lay_material; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_layers.lay_material IS 'Sorte de matériau (ex:  Béton bitumineux AC)';


--
-- TOC entry 3757 (class 0 OID 0)
-- Dependencies: 268
-- Name: COLUMN t_layers.lay_remark; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_layers.lay_remark IS 'Remarques';


--
-- TOC entry 3758 (class 0 OID 0)
-- Dependencies: 268
-- Name: COLUMN t_layers.lay_updatedate; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_layers.lay_updatedate IS 'Date de la mise à jour, la création est une mise à jour (système)';


--
-- TOC entry 3759 (class 0 OID 0)
-- Dependencies: 268
-- Name: COLUMN t_layers.lay_updateuser; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_layers.lay_updateuser IS 'Auteur de la mise à jour (système)';


--
-- TOC entry 3760 (class 0 OID 0)
-- Dependencies: 268
-- Name: COLUMN t_layers.lay_statut; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_layers.lay_statut IS 'Enregistrement actif/ inactif';


--
-- TOC entry 269 (class 1259 OID 305423960)
-- Name: t_methods; Type: TABLE; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE TABLE t_methods (
    mtd_iliid text NOT NULL,
    mtd_shortname character varying(36),
    mtd_name character varying(100),
    mtd_characteristic character varying(128),
    mtd_remark character varying(256),
    mtd_updatedate timestamp without time zone NOT NULL,
    mtd_updateuser character varying(36) NOT NULL,
    mtd_statut boolean DEFAULT true NOT NULL
);


--
-- TOC entry 3761 (class 0 OID 0)
-- Dependencies: 269
-- Name: TABLE t_methods; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON TABLE t_methods IS 'Catalogue des types de méthode de relevé';


--
-- TOC entry 3762 (class 0 OID 0)
-- Dependencies: 269
-- Name: COLUMN t_methods.mtd_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_methods.mtd_iliid IS 'Identifiant interne';


--
-- TOC entry 3763 (class 0 OID 0)
-- Dependencies: 269
-- Name: COLUMN t_methods.mtd_shortname; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_methods.mtd_shortname IS 'Abbréviation';


--
-- TOC entry 3764 (class 0 OID 0)
-- Dependencies: 269
-- Name: COLUMN t_methods.mtd_name; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_methods.mtd_name IS 'Nom';


--
-- TOC entry 3765 (class 0 OID 0)
-- Dependencies: 269
-- Name: COLUMN t_methods.mtd_characteristic; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_methods.mtd_characteristic IS 'Caractéristique de la chaussée (I1, I2, etc..)';


--
-- TOC entry 3766 (class 0 OID 0)
-- Dependencies: 269
-- Name: COLUMN t_methods.mtd_remark; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_methods.mtd_remark IS 'Remarque';


--
-- TOC entry 3767 (class 0 OID 0)
-- Dependencies: 269
-- Name: COLUMN t_methods.mtd_updatedate; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_methods.mtd_updatedate IS 'Date de la mise à jour, la création est une mise à jour (système)';


--
-- TOC entry 3768 (class 0 OID 0)
-- Dependencies: 269
-- Name: COLUMN t_methods.mtd_updateuser; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_methods.mtd_updateuser IS 'Auteur de la mise à jour';


--
-- TOC entry 3769 (class 0 OID 0)
-- Dependencies: 269
-- Name: COLUMN t_methods.mtd_statut; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_methods.mtd_statut IS 'Enregistrement actif/ inactif';


--
-- TOC entry 270 (class 1259 OID 305423967)
-- Name: t_pavement_layers; Type: TABLE; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE TABLE t_pavement_layers (
    pvl_iliid text NOT NULL,
    pvl_geom public.geometry(Polygon,2056),
    pvl_start_sec_iliid text,
    pvl_start_u double precision,
    pvl_end_sec_iliid text,
    pvl_end_u double precision,
    pvl_lay_iliid text,
    pvl_posedate date,
    pvl_thickness real,
    pvl_depth real,
    pvl_pro_iliid text,
    pvl_remark character varying(256),
    pvl_calcul_length numeric(10,2),
    pvl_calcul_area numeric(10,2),
    pvl_updatedate timestamp without time zone NOT NULL,
    pvl_updateuser character varying(36) NOT NULL,
    pvl_statut boolean DEFAULT true NOT NULL
);


--
-- TOC entry 3770 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE t_pavement_layers; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON TABLE t_pavement_layers IS 'Couches de structure';


--
-- TOC entry 3771 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_iliid IS 'Identifiant interne';


--
-- TOC entry 3772 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_geom; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_geom IS 'Polygones libres, pas multipolygone, pas de trou';


--
-- TOC entry 3773 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_start_sec_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_start_sec_iliid IS 'PR début';


--
-- TOC entry 3774 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_start_u; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_start_u IS 'Distance U au PR début [m]';


--
-- TOC entry 3775 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_end_sec_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_end_sec_iliid IS 'PR fin';


--
-- TOC entry 3776 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_end_u; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_end_u IS 'Distance U au PR fin [m]';


--
-- TOC entry 3777 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_lay_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_lay_iliid IS 'Type de couche. Pour le prototype, une liste de valeurs qui se trouivent dans la table Type Couches';


--
-- TOC entry 3778 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_posedate; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_posedate IS 'Date de pose';


--
-- TOC entry 3779 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_thickness; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_thickness IS 'Epaisseur [cm]';


--
-- TOC entry 3780 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_depth; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_depth IS 'Profondeur de fraisage [cm]';


--
-- TOC entry 3781 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_pro_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_pro_iliid IS 'Projet';


--
-- TOC entry 3782 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_remark; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_remark IS 'Remarques';


--
-- TOC entry 3783 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_calcul_length; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_calcul_length IS 'Longueur SRB de la couche (Calculé)';


--
-- TOC entry 3784 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_calcul_area; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_calcul_area IS 'Surface SRB de la couche (Calculé)';


--
-- TOC entry 3785 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_updatedate; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_updatedate IS 'Date de la mise à jour, la création est une mise à jour (système)';


--
-- TOC entry 3786 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_updateuser; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_updateuser IS 'Auteur de la mise à jour (système)';


--
-- TOC entry 3787 (class 0 OID 0)
-- Dependencies: 270
-- Name: COLUMN t_pavement_layers.pvl_statut; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_pavement_layers.pvl_statut IS 'Enregistrement actif/ inactif';


--
-- TOC entry 295 (class 1259 OID 314632185)
-- Name: t_point_location; Type: TABLE; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE TABLE t_point_location (
    ptl_iliid text NOT NULL,
    ptl_geom public.geometry(Point,2056),
    ptl_sec_iliid text,
    ptl_u double precision,
    ptl_m double precision,
    ptl_createdate timestamp without time zone DEFAULT now(),
    ptl_updatedate timestamp without time zone NOT NULL,
    ptl_updateuser character varying(36) NOT NULL,
    ptl_statut boolean DEFAULT true NOT NULL
);


--
-- TOC entry 3788 (class 0 OID 0)
-- Dependencies: 295
-- Name: TABLE t_point_location; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON TABLE t_point_location IS 'Point de référencement linéaire SRB des objets pvl, rco et cgm';


--
-- TOC entry 271 (class 1259 OID 305423974)
-- Name: t_projects; Type: TABLE; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE TABLE t_projects (
    pro_iliid text NOT NULL,
    pro_year integer,
    pro_shortname character varying(36),
    pro_name character varying(72),
    pro_typname character varying(128),
    pro_remark character varying(256),
    pro_updatedate timestamp without time zone NOT NULL,
    pro_updateuser character varying(36) NOT NULL,
    pro_statut boolean DEFAULT true NOT NULL
);


--
-- TOC entry 3789 (class 0 OID 0)
-- Dependencies: 271
-- Name: TABLE t_projects; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON TABLE t_projects IS 'Catalogue des projets';


--
-- TOC entry 3790 (class 0 OID 0)
-- Dependencies: 271
-- Name: COLUMN t_projects.pro_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_projects.pro_iliid IS 'Identifiant interne';


--
-- TOC entry 3791 (class 0 OID 0)
-- Dependencies: 271
-- Name: COLUMN t_projects.pro_year; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_projects.pro_year IS 'Année';


--
-- TOC entry 3792 (class 0 OID 0)
-- Dependencies: 271
-- Name: COLUMN t_projects.pro_shortname; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_projects.pro_shortname IS 'Abbréviation';


--
-- TOC entry 3793 (class 0 OID 0)
-- Dependencies: 271
-- Name: COLUMN t_projects.pro_name; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_projects.pro_name IS 'Nom';


--
-- TOC entry 3794 (class 0 OID 0)
-- Dependencies: 271
-- Name: COLUMN t_projects.pro_typname; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_projects.pro_typname IS 'Type de projet';


--
-- TOC entry 3795 (class 0 OID 0)
-- Dependencies: 271
-- Name: COLUMN t_projects.pro_remark; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_projects.pro_remark IS 'Remarques';


--
-- TOC entry 3796 (class 0 OID 0)
-- Dependencies: 271
-- Name: COLUMN t_projects.pro_updatedate; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_projects.pro_updatedate IS 'Date de la mise à jour, la création est une mise à jour (système)';


--
-- TOC entry 3797 (class 0 OID 0)
-- Dependencies: 271
-- Name: COLUMN t_projects.pro_updateuser; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_projects.pro_updateuser IS 'Auteur de la mise à jour (système)';


--
-- TOC entry 3798 (class 0 OID 0)
-- Dependencies: 271
-- Name: COLUMN t_projects.pro_statut; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_projects.pro_statut IS 'Enregistrement actif/ inactif';


--
-- TOC entry 272 (class 1259 OID 305423981)
-- Name: t_road_controls; Type: TABLE; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE TABLE t_road_controls (
    rco_iliid text NOT NULL,
    rco_geom public.geometry(LineString,2056),
    rco_start_sec_iliid text,
    rco_start_u double precision,
    rco_end_sec_iliid text,
    rco_end_u double precision,
    rco_traffic_lane integer,
    rco_mtd_iliid text,
    rco_statementdate date,
    rco_value_1 real,
    rco_value_2 real,
    rco_value_3 real,
    rco_pro_iliid text,
    rco_note real,
    rco_remark character varying(256),
    rco_updatedate timestamp without time zone NOT NULL,
    rco_updateuser character varying(36) NOT NULL,
    rco_statut boolean DEFAULT true NOT NULL
);


--
-- TOC entry 3799 (class 0 OID 0)
-- Dependencies: 272
-- Name: TABLE t_road_controls; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON TABLE t_road_controls IS 'Etats de la chaussée relevé';


--
-- TOC entry 3800 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_iliid IS 'Identifiant interne';


--
-- TOC entry 3801 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_geom; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_geom IS 'Ligne superposée à la géométrie du segment d''axe';


--
-- TOC entry 3802 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_start_sec_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_start_sec_iliid IS 'PR début';


--
-- TOC entry 3803 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_start_u; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_start_u IS 'Distance U au PR début [m]';


--
-- TOC entry 3804 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_end_sec_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_end_sec_iliid IS 'PR fin';


--
-- TOC entry 3805 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_end_u; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_end_u IS 'Distance U au PR fin [m]';


--
-- TOC entry 3806 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_traffic_lane; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_traffic_lane IS 'Numéro de voie. Idem MISTRA.  -2; -1; 0; 1; 2';


--
-- TOC entry 3807 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_mtd_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_mtd_iliid IS 'Type de méthode';


--
-- TOC entry 3808 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_statementdate; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_statementdate IS 'Date du relevé';


--
-- TOC entry 3809 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_value_1; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_value_1 IS 'Première valeur';


--
-- TOC entry 3810 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_value_2; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_value_2 IS 'Deuxième valeur';


--
-- TOC entry 3811 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_value_3; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_value_3 IS 'Troisième valeur';


--
-- TOC entry 3812 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_pro_iliid; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_pro_iliid IS 'Projet';


--
-- TOC entry 3813 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_note; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_note IS 'Note (fonction règle)';


--
-- TOC entry 3814 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_remark; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_remark IS 'Remarques';


--
-- TOC entry 3815 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_updatedate; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_updatedate IS 'Date de la mise à jour, la création est une mise à jour (système)';


--
-- TOC entry 3816 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_updateuser; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_updateuser IS 'Auteur de la mise à jour (système)';


--
-- TOC entry 3817 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN t_road_controls.rco_statut; Type: COMMENT; Schema: chaussee_dev; Owner: -
--

COMMENT ON COLUMN t_road_controls.rco_statut IS 'Enregistrement actif/ inactif';


--
-- TOC entry 297 (class 1259 OID 315161891)
-- Name: t_sectors; Type: TABLE; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE TABLE t_sectors (
    sec_iliid text NOT NULL,
    sec_sequence double precision,
    sec_name character varying(64),
    sec_length double precision,
    sec_km double precision,
    sec_marker_cat_iliid text,
    sec_markeraccuracyhorizontal real,
    sec_markeraccuracyvertical real,
    sec_markerdescription character varying(256),
    sec_mat_cat_iliid text,
    sec_mataccuracyvertical real,
    sec_mataccuracyhorizontal real,
    sec_mat_v real,
    sec_matdescription character varying(256),
    sec_platetyp_cat_iliid text,
    sec_platelabel_cat_iliid text,
    sec_platefixation_cat_iliid text,
    sec_platelocation_cat_iliid text,
    sec_platelocationaccess character varying(1),
    sec_platetext character varying(256),
    sec_plate_u double precision,
    sec_plate_v real,
    sec_asg_iliid text,
    sec_importdate date,
    sec_refpoint_geom public.geometry,
    sec_line_geom public.geometry,
    CONSTRAINT enforce_dims_sec_refpoint_geom CHECK ((public.st_ndims(sec_refpoint_geom) = 3)),
    CONSTRAINT enforce_geotype_sec_refpoint_geom CHECK (((public.geometrytype(sec_refpoint_geom) = 'POINT'::text) OR (sec_refpoint_geom IS NULL))),
    CONSTRAINT enforce_srid_sec_refpoint_geom CHECK ((public.st_srid(sec_refpoint_geom) = 2056))
);


--
-- TOC entry 3560 (class 2606 OID 315105547)
-- Name: axissegments_pk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_axissegments
    ADD CONSTRAINT axissegments_pk PRIMARY KEY (asg_iliid);


--
-- TOC entry 3539 (class 2606 OID 305424015)
-- Name: controls_pk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_road_controls
    ADD CONSTRAINT controls_pk PRIMARY KEY (rco_iliid);


--
-- TOC entry 3548 (class 2606 OID 305458069)
-- Name: current_geoms_pk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_current_geometries
    ADD CONSTRAINT current_geoms_pk PRIMARY KEY (cgm_iliid);


--
-- TOC entry 3568 (class 2606 OID 315223589)
-- Name: current_geoms_v1_pk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_current_geometries_v1
    ADD CONSTRAINT current_geoms_v1_pk PRIMARY KEY (cgm_iliid);


--
-- TOC entry 3550 (class 2606 OID 306243178)
-- Name: current_views_pk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_current_views
    ADD CONSTRAINT current_views_pk PRIMARY KEY (cuv_iliid);


--
-- TOC entry 3521 (class 2606 OID 305423997)
-- Name: layers_pk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_layers
    ADD CONSTRAINT layers_pk PRIMARY KEY (lay_iliid);


--
-- TOC entry 3524 (class 2606 OID 305424000)
-- Name: methods_pk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_methods
    ADD CONSTRAINT methods_pk PRIMARY KEY (mtd_iliid);


--
-- TOC entry 3526 (class 2606 OID 305424002)
-- Name: methods_shortname_uk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_methods
    ADD CONSTRAINT methods_shortname_uk UNIQUE (mtd_shortname);


--
-- TOC entry 3528 (class 2606 OID 305424004)
-- Name: pavement_pk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_pavement_layers
    ADD CONSTRAINT pavement_pk PRIMARY KEY (pvl_iliid);


--
-- TOC entry 3558 (class 2606 OID 314632193)
-- Name: point_location_pk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_point_location
    ADD CONSTRAINT point_location_pk PRIMARY KEY (ptl_iliid);


--
-- TOC entry 3535 (class 2606 OID 305424011)
-- Name: projects_pk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_projects
    ADD CONSTRAINT projects_pk PRIMARY KEY (pro_iliid);


--
-- TOC entry 3537 (class 2606 OID 305424013)
-- Name: projects_shortname_uk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_projects
    ADD CONSTRAINT projects_shortname_uk UNIQUE (pro_shortname);


--
-- TOC entry 3562 (class 2606 OID 315161903)
-- Name: sectors_name_uk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_sectors
    ADD CONSTRAINT sectors_name_uk UNIQUE (sec_name, sec_asg_iliid);


--
-- TOC entry 3564 (class 2606 OID 315161901)
-- Name: sectors_pk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_sectors
    ADD CONSTRAINT sectors_pk PRIMARY KEY (sec_iliid);


--
-- TOC entry 3566 (class 2606 OID 315161905)
-- Name: sectors_sequence_uk; Type: CONSTRAINT; Schema: chaussee_dev; Owner: -; Tablespace: 
--

ALTER TABLE ONLY t_sectors
    ADD CONSTRAINT sectors_sequence_uk UNIQUE (sec_sequence, sec_asg_iliid);


--
-- TOC entry 3545 (class 1259 OID 305458070)
-- Name: cgm_asg_fki; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX cgm_asg_fki ON t_current_geometries USING btree (cgm_asg_iliid);


--
-- TOC entry 3546 (class 1259 OID 305458071)
-- Name: cgm_geom_idx; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX cgm_geom_idx ON t_current_geometries USING gist (cgm_geom);


--
-- TOC entry 3551 (class 1259 OID 306243213)
-- Name: cuv_end_sec_fki; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX cuv_end_sec_fki ON t_current_views USING btree (cuv_end_sec_iliid);


--
-- TOC entry 3552 (class 1259 OID 306389655)
-- Name: cuv_geom_idx; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX cuv_geom_idx ON t_current_views USING gist (cuv_geom);


--
-- TOC entry 3553 (class 1259 OID 306243214)
-- Name: cuv_lay_fki; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX cuv_lay_fki ON t_current_views USING btree (cuv_lay_iliid);


--
-- TOC entry 3554 (class 1259 OID 306243215)
-- Name: cuv_pro_fki; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX cuv_pro_fki ON t_current_views USING btree (cuv_pro_iliid);


--
-- TOC entry 3555 (class 1259 OID 306243205)
-- Name: cuv_pvl_fki; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX cuv_pvl_fki ON t_current_views USING btree (cuv_pvl_iliid);


--
-- TOC entry 3556 (class 1259 OID 306243212)
-- Name: cuv_start_sec_fki; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX cuv_start_sec_fki ON t_current_views USING btree (cuv_start_sec_iliid);


--
-- TOC entry 3522 (class 1259 OID 305423998)
-- Name: layers_shortname_uk; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX layers_shortname_uk ON t_layers USING btree (lay_shortname);


--
-- TOC entry 3529 (class 1259 OID 305424007)
-- Name: pvl_end_sec_fki; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX pvl_end_sec_fki ON t_pavement_layers USING btree (pvl_end_sec_iliid);


--
-- TOC entry 3530 (class 1259 OID 305881081)
-- Name: pvl_geom_idx; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX pvl_geom_idx ON t_pavement_layers USING gist (pvl_geom);


--
-- TOC entry 3531 (class 1259 OID 305424005)
-- Name: pvl_lay_fki; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX pvl_lay_fki ON t_pavement_layers USING btree (pvl_lay_iliid);


--
-- TOC entry 3532 (class 1259 OID 305424006)
-- Name: pvl_pro_fki; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX pvl_pro_fki ON t_pavement_layers USING btree (pvl_pro_iliid);


--
-- TOC entry 3533 (class 1259 OID 305424008)
-- Name: pvl_start_sec_fki; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX pvl_start_sec_fki ON t_pavement_layers USING btree (pvl_start_sec_iliid);


--
-- TOC entry 3540 (class 1259 OID 305424020)
-- Name: rco_end_sec_fki; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX rco_end_sec_fki ON t_road_controls USING btree (rco_end_sec_iliid);


--
-- TOC entry 3541 (class 1259 OID 306234689)
-- Name: rco_geom_idx; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX rco_geom_idx ON t_road_controls USING btree (rco_geom);


--
-- TOC entry 3542 (class 1259 OID 305424016)
-- Name: rco_mtd_fki; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX rco_mtd_fki ON t_road_controls USING btree (rco_mtd_iliid);


--
-- TOC entry 3543 (class 1259 OID 305424017)
-- Name: rco_pro_fki; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX rco_pro_fki ON t_road_controls USING btree (rco_pro_iliid);


--
-- TOC entry 3544 (class 1259 OID 305424018)
-- Name: rco_start_sec_fki; Type: INDEX; Schema: chaussee_dev; Owner: -; Tablespace: 
--

CREATE INDEX rco_start_sec_fki ON t_road_controls USING btree (rco_start_sec_iliid);


--
-- TOC entry 3580 (class 2620 OID 315223590)
-- Name: timestamp_trg; Type: TRIGGER; Schema: chaussee_dev; Owner: -
--

CREATE TRIGGER timestamp_trg BEFORE INSERT OR UPDATE ON t_current_geometries_v1 FOR EACH ROW EXECUTE PROCEDURE timestamp_fct();


--
-- TOC entry 3579 (class 2606 OID 306243189)
-- Name: cuv_end_sec_fk; Type: FK CONSTRAINT; Schema: chaussee_dev; Owner: -
--

ALTER TABLE ONLY t_current_views
    ADD CONSTRAINT cuv_end_sec_fk FOREIGN KEY (cuv_end_sec_iliid) REFERENCES mistra.t_sectors(sec_iliid);


--
-- TOC entry 3577 (class 2606 OID 306243199)
-- Name: cuv_lay_fk; Type: FK CONSTRAINT; Schema: chaussee_dev; Owner: -
--

ALTER TABLE ONLY t_current_views
    ADD CONSTRAINT cuv_lay_fk FOREIGN KEY (cuv_lay_iliid) REFERENCES t_layers(lay_iliid);


--
-- TOC entry 3578 (class 2606 OID 306243194)
-- Name: cuv_pro_fk; Type: FK CONSTRAINT; Schema: chaussee_dev; Owner: -
--

ALTER TABLE ONLY t_current_views
    ADD CONSTRAINT cuv_pro_fk FOREIGN KEY (cuv_pro_iliid) REFERENCES t_projects(pro_iliid);


--
-- TOC entry 3575 (class 2606 OID 306388783)
-- Name: cuv_pvl_fk; Type: FK CONSTRAINT; Schema: chaussee_dev; Owner: -
--

ALTER TABLE ONLY t_current_views
    ADD CONSTRAINT cuv_pvl_fk FOREIGN KEY (cuv_pvl_iliid) REFERENCES t_pavement_layers(pvl_iliid) ON DELETE CASCADE;


--
-- TOC entry 3576 (class 2606 OID 306243207)
-- Name: cuv_start_sec_fk; Type: FK CONSTRAINT; Schema: chaussee_dev; Owner: -
--

ALTER TABLE ONLY t_current_views
    ADD CONSTRAINT cuv_start_sec_fk FOREIGN KEY (cuv_start_sec_iliid) REFERENCES mistra.t_sectors(sec_iliid);


--
-- TOC entry 3569 (class 2606 OID 306242614)
-- Name: pvl_end_sec_fk; Type: FK CONSTRAINT; Schema: chaussee_dev; Owner: -
--

ALTER TABLE ONLY t_pavement_layers
    ADD CONSTRAINT pvl_end_sec_fk FOREIGN KEY (pvl_end_sec_iliid) REFERENCES mistra.t_sectors(sec_iliid);


--
-- TOC entry 3572 (class 2606 OID 305424026)
-- Name: pvl_lay_fk; Type: FK CONSTRAINT; Schema: chaussee_dev; Owner: -
--

ALTER TABLE ONLY t_pavement_layers
    ADD CONSTRAINT pvl_lay_fk FOREIGN KEY (pvl_lay_iliid) REFERENCES t_layers(lay_iliid);


--
-- TOC entry 3571 (class 2606 OID 305424031)
-- Name: pvl_pro_fk; Type: FK CONSTRAINT; Schema: chaussee_dev; Owner: -
--

ALTER TABLE ONLY t_pavement_layers
    ADD CONSTRAINT pvl_pro_fk FOREIGN KEY (pvl_pro_iliid) REFERENCES t_projects(pro_iliid);


--
-- TOC entry 3570 (class 2606 OID 306242609)
-- Name: pvl_start_sec_fk; Type: FK CONSTRAINT; Schema: chaussee_dev; Owner: -
--

ALTER TABLE ONLY t_pavement_layers
    ADD CONSTRAINT pvl_start_sec_fk FOREIGN KEY (pvl_start_sec_iliid) REFERENCES mistra.t_sectors(sec_iliid);


--
-- TOC entry 3574 (class 2606 OID 305424036)
-- Name: rco_mtd_fk; Type: FK CONSTRAINT; Schema: chaussee_dev; Owner: -
--

ALTER TABLE ONLY t_road_controls
    ADD CONSTRAINT rco_mtd_fk FOREIGN KEY (rco_mtd_iliid) REFERENCES t_methods(mtd_iliid);


--
-- TOC entry 3573 (class 2606 OID 305424041)
-- Name: rco_pro_fk; Type: FK CONSTRAINT; Schema: chaussee_dev; Owner: -
--

ALTER TABLE ONLY t_road_controls
    ADD CONSTRAINT rco_pro_fk FOREIGN KEY (rco_pro_iliid) REFERENCES t_projects(pro_iliid);


-- Completed on 2017-11-17 15:38:38

--
-- PostgreSQL database dump complete
--


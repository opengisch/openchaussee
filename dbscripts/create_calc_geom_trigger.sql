CREATE OR REPLACE FUNCTION chaussee_dev.calc_geom() RETURNS trigger AS $BODY$
BEGIN
  NEW.pvl_line_geom = ST_LineSubstring(
    (
    SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid 
    ),
    (
    ST_LineLocatePoint( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ), (SELECT sec_refpoint_geom FROM chaussee_dev.t_sectors WHERE sec_iliid = NEW.pvl_start_sec_iliid ) )
    +
    NEW.pvl_start_u/ST_Length( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ) )
    ),
    (
    ST_LineLocatePoint( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ), (SELECT sec_refpoint_geom FROM chaussee_dev.t_sectors WHERE sec_iliid = NEW.pvl_end_sec_iliid ) )
    +
    NEW.pvl_end_u/ST_Length( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ) )
    )
  );

  NEW.pvl_geom_area = ST_Intersection( ST_Buffer( NEW.pvl_line_geom, 20 ), ( SELECT ST_Collect( cgm_geom ) FROM chaussee_dev.t_current_geometries_v1 WHERE cgm_asg_iliid = NEW.pvl_asg_iliid ) );

  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS calc_geom_before_insert ON chaussee_dev.t_pavement_layers;

CREATE TRIGGER calc_geom_before_insert
  BEFORE INSERT
  ON chaussee_dev.t_pavement_layers
  FOR EACH ROW
  EXECUTE PROCEDURE chaussee_dev.calc_geom();

CREATE OR REPLACE FUNCTION chaussee_dev.calc_geom_on_update() RETURNS trigger AS $BODY$
BEGIN

  IF NOT( NEW.pvl_line_geom = OLD.pvl_line_geom ) THEN
  
    IF NOT( NEW.pvl_start_sec_iliid = OLD.pvl_start_sec_iliid AND NEW.pvl_end_sec_iliid  = OLD.pvl_end_sec_iliid AND NEW.pvl_start_u = OLD.pvl_start_u AND NEW.pvl_end_u = OLD.pvl_end_u ) THEN
      RAISE EXCEPTION 'Change of geometry and refpoints/offsets at same transaction not allowed';
    END IF;
        
    NEW.pvl_start_sec_iliid =
    (
      SELECT sec_iliid 
      FROM chaussee_dev.t_sectors 
      WHERE sec_asg_iliid = NEW.pvl_asg_iliid 
      AND ST_LineLocatePoint( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ), sec_refpoint_geom ) <= ST_LineLocatePoint( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ), ST_StartPoint( NEW.pvl_line_geom ) )
      ORDER BY ST_LineLocatePoint( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ), sec_refpoint_geom ) DESC
      LIMIT 1
    );
    
    NEW.pvl_start_u = 
    ST_Length( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ) )
    *
    (
     ( ST_LineLocatePoint( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ), ST_StartPoint( NEW.pvl_line_geom ) ) )
      -
     ( ST_LineLocatePoint( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ), (SELECT sec_refpoint_geom FROM chaussee_dev.t_sectors WHERE sec_iliid = NEW.pvl_start_sec_iliid ) ) )
    );

    NEW.pvl_end_sec_iliid = 
    (
      SELECT sec_iliid 
      FROM chaussee_dev.t_sectors 
      WHERE sec_asg_iliid = NEW.pvl_asg_iliid 
      AND ST_LineLocatePoint( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ), sec_refpoint_geom ) <= ST_LineLocatePoint( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ), ST_EndPoint( NEW.pvl_line_geom ) )
      ORDER BY ST_LineLocatePoint( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ), sec_refpoint_geom ) DESC
      LIMIT 1
    );
    
    NEW.pvl_end_u = 
    ST_Length( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ) )
    *
    (
      ( ST_LineLocatePoint( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ), ST_EndPoint( NEW.pvl_line_geom ) ) )
      -
      ( ST_LineLocatePoint( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ), (SELECT sec_refpoint_geom FROM chaussee_dev.t_sectors WHERE sec_iliid = NEW.pvl_end_sec_iliid ) ) )
    );
  END IF;
  
  NEW.pvl_line_geom = ST_LineSubstring(
    (
      SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid 
    ),
    (
      ST_LineLocatePoint( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ), (SELECT sec_refpoint_geom FROM chaussee_dev.t_sectors WHERE sec_iliid = NEW.pvl_start_sec_iliid ) )
      +
      NEW.pvl_start_u/ST_Length( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ) )
    ),
    (
      ST_LineLocatePoint( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ), (SELECT sec_refpoint_geom FROM chaussee_dev.t_sectors WHERE sec_iliid = NEW.pvl_end_sec_iliid ) )
      +
      NEW.pvl_end_u/ST_Length( (SELECT asg_geom FROM chaussee_dev.t_axissegments WHERE asg_iliid = NEW.pvl_asg_iliid ) )
    )
  );
  
  RETURN NEW;
END; $BODY$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS calc_geom_before_update ON chaussee_dev.t_pavement_layers;

CREATE TRIGGER calc_geom_before_update
  BEFORE UPDATE
  ON chaussee_dev.t_pavement_layers
  FOR EACH ROW
  EXECUTE PROCEDURE chaussee_dev.calc_geom_on_update();
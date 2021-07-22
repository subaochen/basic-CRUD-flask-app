--{{{
DROP TRIGGER IF EXISTS update_stock_bucket ON stock_bucket;
DROP FUNCTION IF EXISTS update_stock_bucket();
CREATE FUNCTION update_stock_bucket() RETURNS trigger AS $body$
DECLARE
BEGIN
    IF (TG_OP = 'INSERT') THEN
        update stock_bucket set status='NOT_OPENED' where id=NEW.id;
        if NEW.code is null then
            if NEW.xtp_code is not null then
                update stock_bucket set code=(case substring(xtp_code from 1 for 1) when '6' then 'sh' when '0' then 'sz' end) || '.' || NEW.xtp_code where id=NEW.id;
            end if;
        end if;
    END IF;
    RETURN NULL;
    -- RETURN NEW;
END;
$body$ LANGUAGE plpgsql;
CREATE TRIGGER update_stock_bucket AFTER INSERT ON stock_bucket
    FOR EACH ROW EXECUTE PROCEDURE update_stock_bucket();
--}}}

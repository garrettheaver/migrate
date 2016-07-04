--
-- _versions
--
CREATE SEQUENCE sq_versions;

CREATE TABLE _versions
(
  id int NOT NULL DEFAULT nextval('sq_versions'),
  CONSTRAINT pk_versions PRIMARY KEY (id),
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  filename text NOT NULL
);


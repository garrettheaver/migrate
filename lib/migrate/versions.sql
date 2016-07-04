--
-- _versions
--
CREATE SEQUENCE _sq_versions;

CREATE TABLE _versions
(
  id int NOT NULL DEFAULT nextval('_sq_versions'),
  CONSTRAINT _pk_versions PRIMARY KEY (id),
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  migration text NOT NULL
);


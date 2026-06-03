-- ====================================================================
-- SCRIPT DE ASIGNACIÓN DE PRIVILEGIOS Y CONFIGURACIÓN DE RESPALDO
-- ====================================================================

ALTER SESSION SET CONTAINER = XEPDB1;

--  Conceder permiso explícito al usuario del proyecto para el desarrollo de objetos de tipo Vista.
GRANT CREATE VIEW TO usuario_ile;

-- 3. Crear un objeto de tipo DIRECTORIO dentro de Oracle que sirve como un "acceso directo".
CREATE OR REPLACE DIRECTORY dir_respaldos AS 'C:\respaldos';

-- 4. Otorgar privilegios de lectura y escritura sobre el directorio recién creado al usuario operativo.
GRANT READ, WRITE ON DIRECTORY dir_respaldos TO usuario_ile;
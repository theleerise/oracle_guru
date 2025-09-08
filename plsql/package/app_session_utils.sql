/*==============================================================================
    PAQUETE: APP_SESSION_UTIL
    AUTOR  : Elieser Damián Castro Eusebio 
    FECHA  : 2022-05-13

    PROPÓSITO
    ---------
    Utilidades para gestionar metadatos de sesión en Oracle:
        - CLIENT_IDENTIFIER
        - MODULE
        - ACTION
        - CLIENT_INFO

    USOS TÍPICOS
    ------------
        - Auditoría y trazabilidad de acciones por usuario.
        - Monitorización en V$SESSION / V$ACTIVE_SESSION_HISTORY.
        - Marcado de jobs/batch con módulo/acción.

    VISTAS / CONTEXTO RELACIONADO
    -----------------------------
        - SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER' | 'MODULE' | 'ACTION' | 'CLIENT_INFO')
        - V$SESSION (COLUMNAS: CLIENT_IDENTIFIER, MODULE, ACTION, CLIENT_INFO)

    EJEMPLO RÁPIDO
    --------------
        BEGIN
            APP_SESSION_UTIL.SET_SESSION_INFO(
                  p_client_identifier => 'USR_42'
                , p_module            => 'ORDENES'
                , p_action            => 'ALTA'
                , p_client_info       => 'APP_WEB_V1'
            );
        END;
        /

        DECLARE
            v_id   VARCHAR2(64);
            v_mod  VARCHAR2(48);
            v_act  VARCHAR2(32);
            v_info VARCHAR2(64);
        BEGIN
            APP_SESSION_UTIL.GET_SESSION_INFO(v_id, v_mod, v_act, v_info);
            DBMS_OUTPUT.PUT_LINE('ID='||v_id||' MOD='||v_mod||' ACT='||v_act||' INFO='||v_info);
        END;
        /

        BEGIN
            APP_SESSION_UTIL.CLEAR_SESSION_INFO;
        END;
        /

    CONSIDERACIONES
    ---------------
        - Los valores se TRUNCAN a los límites permitidos por las APIs:
              CLIENT_IDENTIFIER  => 64
              MODULE             => 48
              ACTION             => 32
              CLIENT_INFO        => 64
        - Invocar SET_SESSION_INFO al ENTRAR a cada unidad funcional
          (pantalla/servicio) y CLEAR_SESSION_INFO al SALIR si procede.
        - Evitar datos personales sensibles en CLIENT_INFO.

    HISTORIAL
    ---------
        v1.0  - Versión inicial.
==============================================================================*/
CREATE OR REPLACE PACKAGE APP_SESSION_UTIL AS

    /*--------------------------------------------------------------------------
        PROCEDURE: SET_SESSION_INFO
        PROPÓSITO : Establece los metadatos de la sesión actual.

        PARÁMETROS
        ----------
            p_client_identifier   IN VARCHAR2
                Identificador lógico de cliente/usuario/tenant (máx. 64).

            p_module              IN VARCHAR2
                Módulo o componente de aplicación (máx. 48).

            p_action              IN VARCHAR2
                Acción dentro del módulo (máx. 32). Ej.: 'LOGIN', 'ALTA', 'CONSULTA'.

            p_client_info         IN VARCHAR2 DEFAULT NULL
                Información adicional (máx. 64). Opcional.

        EFECTOS
        -------
            - DBMS_SESSION.SET_IDENTIFIER
            - DBMS_APPLICATION_INFO.SET_MODULE
            - DBMS_APPLICATION_INFO.SET_CLIENT_INFO (si se proporciona)

        NOTAS
        -----
            - Los valores se truncan para respetar los límites de cada API.
            - Útil para correlacionar sesiones y trazas en V$SESSION.

        EJEMPLO
        -------
            BEGIN
                APP_SESSION_UTIL.SET_SESSION_INFO('USR_42','ORDENES','ALTA','APP_WEB_V1');
            END;
    --------------------------------------------------------------------------*/
    PROCEDURE SET_SESSION_INFO(
          p_client_identifier   IN VARCHAR2
        , p_module              IN VARCHAR2
        , p_action              IN VARCHAR2
        , p_client_info         IN VARCHAR2 DEFAULT NULL
    );

    /*--------------------------------------------------------------------------
        PROCEDURE: CLEAR_SESSION_INFO
        PROPÓSITO : Limpia los metadatos de sesión previamente establecidos.

        EFECTOS
        -------
            - DBMS_SESSION.CLEAR_IDENTIFIER
            - DBMS_APPLICATION_INFO.SET_MODULE(NULL, NULL)
            - DBMS_APPLICATION_INFO.SET_CLIENT_INFO(NULL)

        CUÁNDO USAR
        -----------
            - Al finalizar un flujo si no se desea heredar el contexto.
            - Antes de reutilizar una sesión de pool para otro usuario.
    --------------------------------------------------------------------------*/
    PROCEDURE CLEAR_SESSION_INFO;

    /*--------------------------------------------------------------------------
        PROCEDURE: GET_SESSION_INFO
        PROPÓSITO : Devuelve los metadatos de sesión vigentes desde USERENV.

        PARÁMETROS (OUT)
        ----------------
            p_client_identifier   OUT VARCHAR2
            p_module              OUT VARCHAR2
            p_action              OUT VARCHAR2
            p_client_info         OUT VARCHAR2

        FUENTE DE DATOS
        ---------------
            - SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER' | 'MODULE' | 'ACTION' | 'CLIENT_INFO')

        EJEMPLO
        -------
            DECLARE
                v_id   VARCHAR2(64);
                v_mod  VARCHAR2(48);
                v_act  VARCHAR2(32);
                v_info VARCHAR2(64);
            BEGIN
                APP_SESSION_UTIL.GET_SESSION_INFO(v_id, v_mod, v_act, v_info);
                DBMS_OUTPUT.PUT_LINE(v_id||'|'||v_mod||'|'||v_act||'|'||v_info);
            END;
    --------------------------------------------------------------------------*/
    PROCEDURE GET_SESSION_INFO(
          p_client_identifier   OUT VARCHAR2
        , p_module              OUT VARCHAR2
        , p_action              OUT VARCHAR2
        , p_client_info         OUT VARCHAR2
    );

END APP_SESSION_UTIL;
/
SHOW ERRORS


/*==============================================================================
    IMPLEMENTACIÓN DEL PAQUETE: APP_SESSION_UTIL
==============================================================================*/
CREATE OR REPLACE PACKAGE BODY APP_SESSION_UTIL AS

    /* VER SET_SESSION_INFO EN LA ESPECIFICACIÓN PARA DOCUMENTACIÓN COMPLETA */
    PROCEDURE SET_SESSION_INFO(
          p_client_identifier   IN VARCHAR2
        , p_module              IN VARCHAR2
        , p_action              IN VARCHAR2
        , p_client_info         IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        -- CLIENT_IDENTIFIER (LÍMITE 64)
        DBMS_SESSION.SET_IDENTIFIER(SUBSTR(p_client_identifier, 1, 64));

        -- MODULE (48) Y ACTION (32)
        DBMS_APPLICATION_INFO.SET_MODULE(
              SUBSTR(p_module, 1, 48)
            , SUBSTR(p_action, 1, 32)
        );

        -- CLIENT_INFO (64) OPCIONAL
        IF p_client_info IS NOT NULL THEN
            DBMS_APPLICATION_INFO.SET_CLIENT_INFO(SUBSTR(p_client_info, 1, 64));
        END IF;
    END SET_SESSION_INFO;

    /* VER CLEAR_SESSION_INFO EN LA ESPECIFICACIÓN PARA DOCUMENTACIÓN COMPLETA */
    PROCEDURE CLEAR_SESSION_INFO IS
    BEGIN
        DBMS_SESSION.CLEAR_IDENTIFIER;
        DBMS_APPLICATION_INFO.SET_MODULE(NULL, NULL);
        DBMS_APPLICATION_INFO.SET_CLIENT_INFO(NULL);
    END CLEAR_SESSION_INFO;

    /* VER GET_SESSION_INFO EN LA ESPECIFICACIÓN PARA DOCUMENTACIÓN COMPLETA */
    PROCEDURE GET_SESSION_INFO(
          p_client_identifier   OUT VARCHAR2
        , p_module              OUT VARCHAR2
        , p_action              OUT VARCHAR2
        , p_client_info         OUT VARCHAR2
    ) IS
    BEGIN
        SELECT  SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')
             ,  SYS_CONTEXT('USERENV', 'MODULE')
             ,  SYS_CONTEXT('USERENV', 'ACTION')
             ,  SYS_CONTEXT('USERENV', 'CLIENT_INFO')
        INTO    p_client_identifier
             ,  p_module
             ,  p_action
             ,  p_client_info
        FROM    DUAL;
    END GET_SESSION_INFO;

END APP_SESSION_UTIL;
/
SHOW ERRORS

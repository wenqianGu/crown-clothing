select distinct :Para_DD_Year.YEAR||' '||:Para_DD_Review.Review_Period "ReviewPeriod",
       :Para_DD_Status.status "Status",
       Query1."StudentID" "StudentID",
       Query1."FirstName" "FirstName",
       Query1."LastName" "LastName",
       Query1."Faculty" "Faculty",
       STVCAMP.STVCAMP_DESC "Campus",
       Query1."DegreeCode" "DegreeCode",
       Query1."DegreeSeq" "DegreeSeq",
       Query1."DegreeStatus" "DegreeStatus",
       case when (select count(SGRSATT.SGRSATT_PIDM)
                  from SGRSATT
                  where SGRSATT.SGRSATT_PIDM = Query1."PIDM"
                   and SGRSATT.SGRSATT_ATTS_CODE in( 'EIP', 'EIPT')
                   and SGRSATT.SGRSATT_TERM_CODE_EFF = (SELECT MAX(A.SGRSATT_TERM_CODE_EFF)
                                                       FROM SGRSATT A
                                                       WHERE A.SGRSATT_PIDM = SGRSATT.SGRSATT_PIDM)) >='1'
       then 'Yes'
       else 'No'
       End "EIP",
       'Trigger 1' "Reason",
       (SELECT STVCITZ.STVCITZ_DESC
          FROM STVCITZ, SPBPERS
          WHERE SPBPERS.SPBPERS_PIDM = Query1."PIDM"
          AND STVCITZ.STVCITZ_CODE = SPBPERS.SPBPERS_CITZ_CODE) "Citizenship",
       (SELECT STVETHN.STVETHN_DESC
              FROM STVETHN, SPBPERS
              WHERE SPBPERS.SPBPERS_PIDM = Query1."PIDM"
              AND SPBPERS.SPBPERS_ETHN_CODE = STVETHN.STVETHN_CODE) "ATSI",
       ACU.SZKFUNC.GET_EMAIL_ADDRESS (Query1."StudentID", 'STDN') "StudentEmail",
       ACU.SZKFUNC.GET_EMAIL_ADDRESS (Query1."StudentID", 'PERS') "PersonalEmail",
       ACU.SZKFUNC.GET_MOBILE_NUMBER (Query1."StudentID") "Mobile",
       (SELECT SPRADDR.SPRADDR_STREET_LINE1
                 FROM SPRADDR
                 WHERE Query1."PIDM" = SPRADDR.SPRADDR_PIDM
                 AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
                 AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
                 AND SPRADDR.SPRADDR_TO_DATE is null
                 AND SPRADDR.SPRADDR_STATUS_IND is null
              ) "StreetAddress1",
       (SELECT SPRADDR.SPRADDR_STREET_LINE2
                 FROM SPRADDR
                 WHERE Query1."PIDM" = SPRADDR.SPRADDR_PIDM
                 AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
                 AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
                 AND SPRADDR.SPRADDR_TO_DATE is null
                 AND SPRADDR.SPRADDR_STATUS_IND is null
                 ) "StreetAddress2",
       (SELECT SPRADDR.SPRADDR_CITY
                             FROM SPRADDR
                             WHERE Query1."PIDM" = SPRADDR.SPRADDR_PIDM
                             AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
                             AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
                             AND SPRADDR.SPRADDR_TO_DATE is null
                             AND SPRADDR.SPRADDR_STATUS_IND is null
                            ) "City",
       (SELECT SPRADDR.SPRADDR_STAT_CODE
                             FROM SPRADDR
                             WHERE Query1."PIDM" = SPRADDR.SPRADDR_PIDM
                             AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
                             AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
                             AND SPRADDR.SPRADDR_TO_DATE is null
                             AND SPRADDR.SPRADDR_STATUS_IND is null
                            ) "State",
       (SELECT SPRADDR.SPRADDR_ZIP
                 FROM SPRADDR
                WHERE Query1."PIDM" = SPRADDR.SPRADDR_PIDM
                  AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
                  AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
                  AND SPRADDR.SPRADDR_TO_DATE is null
                  AND SPRADDR.SPRADDR_STATUS_IND is null
                ) "Postcode",
       ( SELECT TO_CHAR(MAX(SHRTCKG.SHRTCKG_ACTIVITY_DATE),'DD/MM/YYYY')
           from SATURN.SHRTCKN SHRTCKN,
                SATURN.SHRTCKG SHRTCKG,
                SATURN.SHRTCKD SHRTCKD,
                SATURN.SHRDGMR SHRDGMR
         where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
             And SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+)
             and SHRTCKD.SHRTCKD_PIDM = Query1."PIDM"
             and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = Query1."DegreeSeq" )
             and SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
             and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
             and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                          FROM SHRTCKG
                                          WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                          AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                          AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO)
             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
             and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
             and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
             and ( (:Para_DD_Review.Index =1 and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82'))
                 or ( :Para_DD_Review.Index ='2' and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) )
       ) "LastFailedGradeDate",
       (SELECT LISTAGG(TO_CHAR(A.SPRCMNT_DATE,'DD/MM/YYYY')||','||A.SPRCMNT_CMTT_CODE||','||A.SPRCMNT_TEXT||';') WITHIN GROUP (ORDER BY A.SPRCMNT_ACTIVITY_DATE)
          FROM SPRCMNT A
         WHERE A.SPRCMNT_PIDM = Query1."PIDM"
           AND A.SPRCMNT_ACTIVITY_DATE >=( SELECT MAX(SHRTCKG.SHRTCKG_ACTIVITY_DATE)
                                             from SATURN.SHRTCKN SHRTCKN,
                                                  SATURN.SHRTCKG SHRTCKG,
                                                  SATURN.SHRTCKD SHRTCKD,
                                                  SATURN.SHRDGMR SHRDGMR
                                             where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                             And SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+)
                                             and SHRTCKD.SHRTCKD_PIDM = Query1."PIDM"
                                             and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = Query1."DegreeSeq"
                                             and SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                             and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                             and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                                                         FROM SHRTCKG
                                                                         WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                                         AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                                         AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO)
                                             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                             and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
                                             and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                                             and ( (:Para_DD_Review.Index =1 and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82'))
                                             or ( :Para_DD_Review.Index ='2' and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) )
       ))) "CommentText"
  from SATURN.STVCAMP STVCAMP,
       ( select distinct datascope1."ID" "StudentID",
                datascope1."FirstName" "FirstName",
                datascope1."LastName" "LastName",
                datascope1."DegreeSeq" "DegreeSeq",
                SHRDGMR1.SHRDGMR_DEGC_CODE "DegreeCode",
                STVDEGS.STVDEGS_DESC "DegreeStatus",
                datascope1."PctFailedCP" "FailedCPPct",
                datascope1."PctFailedUnit" "FailedUnitPct",
                Count( FailedUnit1."InternalId" ) "Times",
                datascope1."InternalId" "PIDM",
                SHRDGMR1.SHRDGMR_COLL_CODE_1 "Faculty",
                SHRDGMR1.SHRDGMR_CAMP_CODE "Campus"
           from SATURN.SHRDGMR SHRDGMR1,
                SATURN.STVDEGS STVDEGS,
                ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                         TotalUnit21."DegreeSeqNo" "DegreeSeq",
                         SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                         SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                         ROUND(FailedUnitCount11."CreditHours"/(DECODE((NVL(TotalUnit21."TotalCP",0) + NVL(BlankUnitCount."CreditHours",0)),0,1,(NVL(TotalUnit21."TotalCP",0) + NVL(BlankUnitCount."CreditHours",0)))),2)*100 "PctFailedCP",
                         ROUND(FailedUnitCount11."Unit"/(DECODE((NVL(TotalUnit21."ToatlUnitCount",0) + NVL(BlankUnitCount."Count",0)),0,1,(NVL(TotalUnit21."ToatlUnitCount",0) + NVL(BlankUnitCount."Count",0)))),2)*100 "PctFailedUnit",
                         (select  listagg(SGRSATT.SGRSATT_TERM_CODE_EFF|| ', ') within group (order by SGRSATT.SGRSATT_PIDM)
                                 from sgrsatt
                                 where SGRSATT.SGRSATT_PIDM = SPRIDEN.SPRIDEN_PIDM
                                  and SGRSATT.SGRSATT_ATTS_CODE = 'SHCA'
                                  and SGRSATT.SGRSATT_TERM_CODE_EFF > (SELECT MIN(A.SHRTCKD_TERM_CODE)
                                                                       FROM SHRTCKD A
                                                                       WHERE A.SHRTCKD_PIDM = FailedUnitCount11."InternalId"
                                                                       AND A.SHRTCKD_DGMR_SEQ_NO = TotalUnit21."DegreeSeqNo"
                                                                       AND A.SHRTCKD_APPLIED_IND ='Y')
                                  group by SGRSATT.SGRSATT_PIDM) "SHCA",
                         SPRIDEN.SPRIDEN_PIDM "InternalId"
                    from SATURN.SPRIDEN SPRIDEN,
                         ( select distinct SHRTCKN.SHRTCKN_PIDM "PIDM",
                                  Count( SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB ) "ToatlUnitCount",
                                  Sum( SHRTCKG.SHRTCKG_CREDIT_HOURS ) "TotalCP",
                                  SHRDGMR.SHRDGMR_SEQ_NO "DegreeSeqNo"
                             from SATURN.SHRTCKN SHRTCKN,
                                  SATURN.SHRTCKG SHRTCKG,
                                  SATURN.SHRTCKD SHRTCKD,
                                  SATURN.SHRDGMR SHRDGMR
                            where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+)
                                    and SHRTCKD.SHRTCKD_PIDM = SHRDGMR.SHRDGMR_PIDM
                                    and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = SHRDGMR.SHRDGMR_SEQ_NO )
                              and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                      and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                      and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                        FROM SHRTCKG
                                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                      )
                                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('HD', 'DI', 'CR', 'PA', 'PX', 'NN', 'NH', 'NU', 'WN','PS','IP',
                                      'NF',
                                      'RP',
                                      'DE',
                                      'RW',
                                      'CU',
                                      'CE',
                                      'NL')
                                      and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
                                      and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                                      and ( :Para_DD_Review.Index =1
                                        and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                        or ( :Para_DD_Review.Index ='2'
                                          and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                and ( SHRTCKD_APPLIED_IND = 'Y' ) )
                            group by SHRTCKN.SHRTCKN_PIDM,
                                     SHRDGMR.SHRDGMR_SEQ_NO
                            order by SHRTCKN.SHRTCKN_TERM_CODE ) TotalUnit21,
                         ( select distinct SHRTCKN.SHRTCKN_PIDM "InternalId",
                                  Count( SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB ) "Unit",
                                  Sum( SHRTCKG.SHRTCKG_CREDIT_HOURS ) "CreditHours",
                                  SHRDGMR.SHRDGMR_SEQ_NO "DegreeSeqNo"
                             from SATURN.SHRTCKN SHRTCKN,
                                  SATURN.SHRTCKG SHRTCKG,
                                  SATURN.SHRTCKD SHRTCKD,
                                  SATURN.SHRDGMR SHRDGMR
                            where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+)
                                    and SHRTCKD.SHRTCKD_PIDM = SHRDGMR.SHRDGMR_PIDM
                                    and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = SHRDGMR.SHRDGMR_SEQ_NO )
                              and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                      and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                      and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                        FROM SHRTCKG
                                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                      )
                                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                      and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
                                      and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                                      and ( :Para_DD_Review.Index =1
                                        and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                        or ( :Para_DD_Review.Index ='2'
                                          and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                and ( SHRTCKD_APPLIED_IND = 'Y' ) )
                            group by SHRTCKN.SHRTCKN_PIDM,
                                     SHRDGMR.SHRDGMR_SEQ_NO
                            order by SHRTCKN.SHRTCKN_TERM_CODE ) FailedUnitCount11,
                         ( select distinct SFRSTCR.SFRSTCR_PIDM "PIDM",
                                  Count( SFRSTCR.SFRSTCR_PIDM ) "Count",
                                  Sum( SFRSTCR.SFRSTCR_CREDIT_HR ) "CreditHours"
                             from SATURN.SFRSTCR SFRSTCR,
                                  SATURN.SHRTCKN SHRTCKN
                            where ( SFRSTCR.SFRSTCR_PIDM = SHRTCKN.SHRTCKN_PIDM (+)
                                    and SFRSTCR.SFRSTCR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE (+)
                                    and SFRSTCR.SFRSTCR_CRN = SHRTCKN.SHRTCKN_CRN (+) )
                              and ( SFRSTCR.SFRSTCR_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                    and SFRSTCR.SFRSTCR_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                    and SFRSTCR.SFRSTCR_GRDE_CODE is null
                                    and (SELECT SHRTCKG.SHRTCKG_GRDE_CODE_FINAL
                                                            FROM SHRTCKG
                                                           WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                             AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                             AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                                             AND SHRTCKG.SHRTCKG_SEQ_NO = (SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                                                                             FROM SHRTCKG
                                                                                            WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                                                             AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                                                             AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                                                                    )) is null
                                    and SFRSTCR.SFRSTCR_RSTS_CODE IN ('RE','RW','DF','DN','DP')
                                    and ( :Para_DD_Review.Index =1
                                      and SUBSTR(SFRSTCR.SFRSTCR_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                      or ( :Para_DD_Review.Index ='2'
                                        and SUBSTR(SFRSTCR.SFRSTCR_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                            group by SFRSTCR.SFRSTCR_PIDM
                            order by SFRSTCR.SFRSTCR_PIDM ) BlankUnitCount
                   where ( SPRIDEN.SPRIDEN_PIDM = TotalUnit21."PIDM"
                           and TotalUnit21."PIDM" = FailedUnitCount11."InternalId" (+)
                           and TotalUnit21."DegreeSeqNo" = FailedUnitCount11."DegreeSeqNo" (+)
                           and SPRIDEN.SPRIDEN_PIDM = BlankUnitCount."PIDM" (+) )
                     and ( ( SPRIDEN.SPRIDEN_ID NOT LIKE 'P%'
                             and ( ROUND(FailedUnitCount11."CreditHours"/(DECODE((NVL(TotalUnit21."TotalCP",0) + NVL(BlankUnitCount."CreditHours",0)),0,1,(NVL(TotalUnit21."TotalCP",0) + NVL(BlankUnitCount."CreditHours",0)))),2)*100 >=50
                               or ROUND(FailedUnitCount11."Unit"/(DECODE((NVL(TotalUnit21."ToatlUnitCount",0) + NVL(BlankUnitCount."Count",0)),0,1,(NVL(TotalUnit21."ToatlUnitCount",0) + NVL(BlankUnitCount."Count",0)))),2)*100 >=50 ) )
                       and ( SPRIDEN_CHANGE_IND is null ) ) ) datascope1,
                ( select distinct SHRTCKD.SHRTCKD_PIDM "InternalId",
                         SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                         CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) ='97'
                              THEN TO_CHAR(STVTERM.STVTERM_ACYR_CODE + 1)
                              ELSE STVTERM.STVTERM_ACYR_CODE
                         END "ReviewYear",
                         CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                         THEN '1'
                         ELSE CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2)  IN ('45','55','60','65','70','56','76','86','87')
                              THEN '2'
                              END
                         END "ReviewPeriod",
                         Sum( SHRTCKG.SHRTCKG_CREDIT_HOURS ) "TotalGreditHours",
                         Count( SHRTCKN.SHRTCKN_CRN ) "TotalUnitCount"
                    from SATURN.SHRTCKD SHRTCKD,
                         SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.STVTERM STVTERM
                   where ( SHRTCKD.SHRTCKD_PIDM = SHRTCKN.SHRTCKN_PIDM
                           and SHRTCKD.SHRTCKD_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                           and SHRTCKD.SHRTCKD_TCKN_SEQ_NO = SHRTCKN.SHRTCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SHRTCKD.SHRTCKD_TERM_CODE = STVTERM.STVTERM_CODE )
                     and ( SHRTCKG.SHRTCKG_SEQ_NO = (SELECT MAX(A.SHRTCKG_SEQ_NO)
                             FROM SHRTCKG A
                             WHERE A.SHRTCKG_PIDM = SHRTCKG.SHRTCKG_PIDM
                             AND A.SHRTCKG_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                             AND A.SHRTCKG_TCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO)
                           and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                           and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL') )
                   group by SHRTCKD.SHRTCKD_PIDM,
                            SHRTCKD.SHRTCKD_DGMR_SEQ_NO,
                            CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) ='97'
                       THEN TO_CHAR(STVTERM.STVTERM_ACYR_CODE + 1)
                       ELSE STVTERM.STVTERM_ACYR_CODE
                  END,
                            CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                  THEN '1'
                  ELSE CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2)  IN ('45','55','60','65','70','56','76','86','87')
                       THEN '2'
                       END
                  END ) FailedUnit1,
                ( select distinct SHRTCKD.SHRTCKD_PIDM "InternalId",
                         SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                         CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) ='97'
                              THEN TO_CHAR(STVTERM.STVTERM_ACYR_CODE + 1)
                              ELSE STVTERM.STVTERM_ACYR_CODE
                         END "ReviewYear",
                         CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                         THEN '1'
                         ELSE CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2)  IN ('45','55','60','65','70','56','76','86','87')
                              THEN '2'
                              END
                         END "ReviewPeriod",
                         Sum( SHRTCKG.SHRTCKG_CREDIT_HOURS ) "TotalGreditHours",
                         Count( SHRTCKN.SHRTCKN_CRN ) "TotalUnitCount"
                    from SATURN.SHRTCKD SHRTCKD,
                         SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.STVTERM STVTERM
                   where ( SHRTCKD.SHRTCKD_PIDM = SHRTCKN.SHRTCKN_PIDM
                           and SHRTCKD.SHRTCKD_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                           and SHRTCKD.SHRTCKD_TCKN_SEQ_NO = SHRTCKN.SHRTCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SHRTCKD.SHRTCKD_TERM_CODE = STVTERM.STVTERM_CODE )
                     and ( SHRTCKG.SHRTCKG_SEQ_NO = (SELECT MAX(A.SHRTCKG_SEQ_NO)
                             FROM SHRTCKG A
                             WHERE A.SHRTCKG_PIDM = SHRTCKG.SHRTCKG_PIDM
                             AND A.SHRTCKG_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                             AND A.SHRTCKG_TCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO)
                           and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                           and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('HD', 'DI', 'CR', 'PA', 'PX', 'NN', 'NH', 'NU', 'WN','PS','IP',
                           'NF',
                           'RP',
                           'DE',
                           'RW',
                           'CU',
                           'CE',
                           'NL') )
                   group by SHRTCKD.SHRTCKD_PIDM,
                            SHRTCKD.SHRTCKD_DGMR_SEQ_NO,
                            CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) ='97'
                       THEN TO_CHAR(STVTERM.STVTERM_ACYR_CODE + 1)
                       ELSE STVTERM.STVTERM_ACYR_CODE
                  END,
                            CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                  THEN '1'
                  ELSE CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2)  IN ('45','55','60','65','70','56','76','86','87')
                       THEN '2'
                       END
                  END ) TotalUnit11,
                ( select distinct SFRSTCR.SFRSTCR_PIDM "PIDM",
                         Count( SFRSTCR.SFRSTCR_PIDM ) "Count",
                         Sum( SFRSTCR.SFRSTCR_CREDIT_HR ) "CreditHours"
                    from SATURN.SFRSTCR SFRSTCR,
                         SATURN.SHRTCKN SHRTCKN
                   where ( SFRSTCR.SFRSTCR_PIDM = SHRTCKN.SHRTCKN_PIDM (+)
                           and SFRSTCR.SFRSTCR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE (+)
                           and SFRSTCR.SFRSTCR_CRN = SHRTCKN.SHRTCKN_CRN (+) )
                     and ( SFRSTCR.SFRSTCR_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                           and SFRSTCR.SFRSTCR_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                           and SFRSTCR.SFRSTCR_GRDE_CODE is null
                           and (SELECT SHRTCKG.SHRTCKG_GRDE_CODE_FINAL
                                                   FROM SHRTCKG
                                                  WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                    AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                    AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                                    AND SHRTCKG.SHRTCKG_SEQ_NO = (SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                                                                    FROM SHRTCKG
                                                                                   WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                                                    AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                                                    AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                                                           )) is null
                           and SFRSTCR.SFRSTCR_RSTS_CODE IN ('RE','RW','DF','DN','DP')
                           and ( :Para_DD_Review.Index =1
                             and SUBSTR(SFRSTCR.SFRSTCR_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                             or ( :Para_DD_Review.Index ='2'
                               and SUBSTR(SFRSTCR.SFRSTCR_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                   group by SFRSTCR.SFRSTCR_PIDM
                   order by SFRSTCR.SFRSTCR_PIDM ) BlankUnit2
          where ( TotalUnit11."InternalId" = FailedUnit1."InternalId" (+)
                  and TotalUnit11."DegreeSeqNo" = FailedUnit1."DegreeSeqNo" (+)
                  and TotalUnit11."ReviewYear" = FailedUnit1."ReviewYear" (+)
                  and TotalUnit11."ReviewPeriod" = FailedUnit1."ReviewPeriod" (+)
                  and datascope1."InternalId" = TotalUnit11."InternalId"
                  and datascope1."DegreeSeq" = TotalUnit11."DegreeSeqNo"
                  and datascope1."InternalId" = SHRDGMR1.SHRDGMR_PIDM
                  and datascope1."DegreeSeq" = SHRDGMR1.SHRDGMR_SEQ_NO
                  and SHRDGMR1.SHRDGMR_DEGS_CODE = STVDEGS.STVDEGS_CODE
                  and datascope1."InternalId" = BlankUnit2."PIDM" (+) )
            and ( datascope1."ID" not like 'P%'
                  and TotalUnit11."ReviewYear"||TotalUnit11."ReviewPeriod" <=:Para_DD_Year.YEAR||:Para_DD_Review.Index
                  and ( ROUND(FailedUnit1."TotalGreditHours"/(DECODE((NVL(TotalUnit11."TotalGreditHours",0) + NVL(BlankUnit2."CreditHours",0)),0,1,(NVL(TotalUnit11."TotalGreditHours",0) + NVL(BlankUnit2."CreditHours",0)))),2)*100 >= 50
                    or ROUND(FailedUnit1."TotalUnitCount"/(DECODE((NVL(TotalUnit11."TotalUnitCount",0) + NVL(BlankUnit2."Count",0)),0,1,(NVL(TotalUnit11."TotalUnitCount",0) + NVL(BlankUnit2."Count",0)))),2)*100 >= 50 ) )
          group by datascope1."ID",
                   datascope1."FirstName",
                   datascope1."LastName",
                   datascope1."DegreeSeq",
                   SHRDGMR1.SHRDGMR_DEGC_CODE,
                   STVDEGS.STVDEGS_DESC,
                   datascope1."PctFailedCP",
                   datascope1."PctFailedUnit",
                   datascope1."InternalId",
                   SHRDGMR1.SHRDGMR_COLL_CODE_1,
                   SHRDGMR1.SHRDGMR_CAMP_CODE
          order by datascope1."ID" ) Query1,
       ( select distinct AllDegreeFailedTimeCount1."InternalId" "PIDM",
                Max( AllDegreeFailedTimeCount1."FailedTimes" + nvl(EqiFailedTimes1."FailedEqiUnitTerrm",0) ) "TotalFailedTime"
           from ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                         SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                         SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                         SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB "Unit",
                         Count( SHRTCKN.SHRTCKN_TERM_CODE||SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB ) "FailedTimes",
                         SPRIDEN.SPRIDEN_PIDM "InternalId"
                    from SATURN.SPRIDEN SPRIDEN,
                         SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.SHRDGMR SHRDGMR1,
                         ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                                  SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                                  SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                                  SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                                  SPRIDEN.SPRIDEN_PIDM "InternalId",
                                  SHRTCKN.SHRTCKN_SUBJ_CODE "SubjAreaCode",
                                  SHRTCKN.SHRTCKN_CRSE_NUMB "CrseNo"
                             from SATURN.SPRIDEN SPRIDEN,
                                  SATURN.SHRTCKN SHRTCKN,
                                  SATURN.SHRTCKG SHRTCKG,
                                  SATURN.SHRTCKD SHRTCKD
                            where ( SPRIDEN.SPRIDEN_PIDM = SHRTCKN.SHRTCKN_PIDM
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+) )
                              and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                      and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                      and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                        FROM SHRTCKG
                                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                      )
                                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                      and SPRIDEN.SPRIDEN_ID NOT LIKE 'P%'
                                      and (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                       FROM SSRATTR A
                                       WHERE A.SSRATTR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                                       AND A.SSRATTR_CRN = SHRTCKN.SHRTCKN_CRN
                                       AND A.SSRATTR_ATTR_CODE = 'CLIN') =0
                                      and ( :Para_DD_Review.Index =1
                                        and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                        or ( :Para_DD_Review.Index ='2'
                                          and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                and ( SPRIDEN_CHANGE_IND is null )
                                and ( SHRTCKD_APPLIED_IND = 'Y' ) ) ) FailedNONCLIN2
                   where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SPRIDEN.SPRIDEN_PIDM = FailedNONCLIN2."InternalId"
                           and FailedNONCLIN2."InternalId" = SHRTCKN.SHRTCKN_PIDM
                           and FailedNONCLIN2."SubjAreaCode" = SHRTCKN.SHRTCKN_SUBJ_CODE
                           and FailedNONCLIN2."CrseNo" = SHRTCKN.SHRTCKN_CRSE_NUMB
                           and FailedNONCLIN2."InternalId" = SHRDGMR1.SHRDGMR_PIDM
                           and FailedNONCLIN2."DegreeSeqNo" = SHRDGMR1.SHRDGMR_SEQ_NO )
                     and ( ( SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                               FROM SHRTCKG
                               WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                               AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                               AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                             )
                             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                             and SHRDGMR1.SHRDGMR_DEGS_CODE <>'AH'
                             and ( :Para_DD_Review.Index =1
                               and (SHRTCKN.SHRTCKN_TERM_CODE <=:Para_DD_Year.YEAR*100+47
                               or SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('81','82'))
                               and SHRTCKN.SHRTCKN_TERM_CODE <>:Para_DD_Year.YEAR*100+45
                               or ( :Para_DD_Review.Index =2
                                 and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97 ) ) )
                       and ( SPRIDEN_CHANGE_IND is null ) )
                   group by SPRIDEN.SPRIDEN_ID,
                            SPRIDEN.SPRIDEN_FIRST_NAME,
                            SPRIDEN.SPRIDEN_LAST_NAME,
                            SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB,
                            SPRIDEN.SPRIDEN_PIDM ) AllDegreeFailedTimeCount1,
                ( select distinct SPRIDEN.SPRIDEN_PIDM "InternalId",
                         Count( SHRTCKN.SHRTCKN_TERM_CODE||Query."EqivSub"||Query."EqivCrsNo" ) "FailedEqiUnitTerrm",
                         Query."SubjectCode"||Query."CrseNo" "FailedUnit"
                    from SATURN.SPRIDEN SPRIDEN,
                         SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.SHRTCKD SHRTCKD,
                         SATURN.SHRDGMR SHRDGMR,
                         ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                                  SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                                  SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                                  SHRTCKN.SHRTCKN_TERM_CODE "Term",
                                  SHRTCKN.SHRTCKN_CRN "CRN",
                                  SHRTCKG.SHRTCKG_GRDE_CODE_FINAL "Grade",
                                  SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                                  (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                   FROM SSRATTR A
                                   WHERE A.SSRATTR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                                   AND A.SSRATTR_CRN = SHRTCKN.SHRTCKN_CRN
                                   AND A.SSRATTR_ATTR_CODE = 'CLIN') "CLIN",
                                  SPRIDEN.SPRIDEN_PIDM "InternalId",
                                  SHRTCKN.SHRTCKN_SUBJ_CODE "SubjAreaCode",
                                  SHRTCKN.SHRTCKN_CRSE_NUMB "CrseNo"
                             from SATURN.SPRIDEN SPRIDEN,
                                  SATURN.SHRTCKN SHRTCKN,
                                  SATURN.SHRTCKG SHRTCKG,
                                  SATURN.SHRTCKD SHRTCKD
                            where ( SPRIDEN.SPRIDEN_PIDM = SHRTCKN.SHRTCKN_PIDM
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+) )
                              and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                      and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                      and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                        FROM SHRTCKG
                                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                      )
                                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                      and SPRIDEN.SPRIDEN_ID NOT LIKE 'P%'
                                      and (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                       FROM SSRATTR A
                                       WHERE A.SSRATTR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                                       AND A.SSRATTR_CRN = SHRTCKN.SHRTCKN_CRN
                                       AND A.SSRATTR_ATTR_CODE = 'CLIN') =0
                                      and ( :Para_DD_Review.Index =1
                                        and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                        or ( :Para_DD_Review.Index ='2'
                                          and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                and ( SPRIDEN_CHANGE_IND is null )
                                and ( SHRTCKD_APPLIED_IND = 'Y' ) )
                            order by SPRIDEN.SPRIDEN_ID,
                                     SHRTCKN.SHRTCKN_TERM_CODE ) FailedNONCLIN2,
                         ( select distinct SSBSECT2.SSBSECT_TERM_CODE "Term",
                                  SSBSECT2.SSBSECT_CRN "CRN",
                                  SSBSECT2.SSBSECT_SUBJ_CODE "SubjectCode",
                                  SSBSECT2.SSBSECT_CRSE_NUMB "CrseNo",
                                  SCREQIV1.SCREQIV_SUBJ_CODE_EQIV "EqivSub",
                                  SCREQIV1.SCREQIV_CRSE_NUMB_EQIV "EqivCrsNo"
                             from SATURN.SSBSECT SSBSECT2,
                                  SATURN.SCREQIV SCREQIV1
                            where ( SSBSECT2.SSBSECT_SUBJ_CODE = SCREQIV1.SCREQIV_SUBJ_CODE
                                    and SSBSECT2.SSBSECT_CRSE_NUMB = SCREQIV1.SCREQIV_CRSE_NUMB )
                              and ( SSBSECT2.SSBSECT_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                    and SSBSECT2.SSBSECT_TERM_CODE < :Para_DD_Year.YEAR *100 + 97
                                    and SCREQIV1.SCREQIV_END_TERM >=SSBSECT2.SSBSECT_TERM_CODE
                                    and SCREQIV1.SCREQIV_EFF_TERM <=SSBSECT2.SSBSECT_TERM_CODE
                                    and (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                     FROM SSRATTR A
                                     WHERE A.SSRATTR_TERM_CODE = SSBSECT2.SSBSECT_TERM_CODE
                                     AND A.SSRATTR_CRN = SSBSECT2.SSBSECT_CRN
                                     AND A.SSRATTR_ATTR_CODE = 'CLIN') =0
                                    and ( :Para_DD_Review.Index =1
                                      and SUBSTR(SSBSECT2.SSBSECT_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                      or ( :Para_DD_Review.Index =2
                                        and SUBSTR(SSBSECT2.SSBSECT_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                            order by 1,
                                     3 ) Query
                   where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO
                           and SPRIDEN.SPRIDEN_PIDM = FailedNONCLIN2."InternalId"
                           and Query."EqivSub" = SHRTCKN.SHRTCKN_SUBJ_CODE
                           and Query."EqivCrsNo" = SHRTCKN.SHRTCKN_CRSE_NUMB
                           and FailedNONCLIN2."InternalId" = SHRDGMR.SHRDGMR_PIDM
                           and FailedNONCLIN2."DegreeSeqNo" = SHRDGMR.SHRDGMR_SEQ_NO
                           and FailedNONCLIN2."Term" = Query."Term"
                           and FailedNONCLIN2."CRN" = Query."CRN"
                           and FailedNONCLIN2."InternalId" = SHRTCKD.SHRTCKD_PIDM )
                     and ( ( SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                             and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                               FROM SHRTCKG
                               WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                               AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                               AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                             )
                             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                             and SHRTCKN.SHRTCKN_TERM_CODE <=Query."Term"
                             and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH' )
                       and ( SPRIDEN_CHANGE_IND is null )
                       and ( SHRTCKD_APPLIED_IND = 'Y' ) )
                   group by SPRIDEN.SPRIDEN_PIDM,
                            Query."SubjectCode"||Query."CrseNo" ) EqiFailedTimes1
          where ( AllDegreeFailedTimeCount1."InternalId" = EqiFailedTimes1."InternalId" (+)
                  and AllDegreeFailedTimeCount1."Unit" = EqiFailedTimes1."FailedUnit" (+) )
          group by AllDegreeFailedTimeCount1."InternalId" ) trigger2,
       ( select distinct SHRTCKD.SHRTCKD_PIDM "PIDM",
                Count( SHRTCKN.SHRTCKN_TERM_CODE||SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB ) "FailedCLINUnitCount"
           from SATURN.SHRTCKN SHRTCKN,
                SATURN.SHRTCKG SHRTCKG,
                SATURN.SHRTCKD SHRTCKD,
                SATURN.SHRDGMR SHRDGMR,
                SATURN.SSRATTR SSRATTR2,
                ( select distinct SHRTCKN.SHRTCKN_PIDM "PIDM",
                         SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                         SHRTCKN.SHRTCKN_SUBJ_CODE "SubjAreaCode",
                         SHRTCKN.SHRTCKN_CRSE_NUMB "CrseNo"
                    from SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.SHRTCKD SHRTCKD,
                         SATURN.SSRATTR SSRATTR,
                         SATURN.SHRDGMR SHRDGMR1
                   where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_TERM_CODE = SSRATTR.SSRATTR_TERM_CODE
                           and SHRTCKN.SHRTCKN_CRN = SSRATTR.SSRATTR_CRN
                           and SHRTCKD.SHRTCKD_PIDM = SHRDGMR1.SHRDGMR_PIDM
                           and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = SHRDGMR1.SHRDGMR_SEQ_NO )
                     and ( ( SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                               FROM SHRTCKG
                               WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                               AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                               AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                             )
                             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                             and SSRATTR.SSRATTR_ATTR_CODE ='CLIN'
                             and SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                             and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                             and SHRDGMR1.SHRDGMR_DEGS_CODE <>'AH'
                             and ( :Para_DD_Review.Index =1
                               and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                               or ( :Para_DD_Review.Index ='2'
                                 and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                       and ( SHRTCKD_APPLIED_IND = 'Y' ) ) ) FailedCLIN1
          where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                  and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                  and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                  and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM
                  and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE
                  and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO
                  and FailedCLIN1."PIDM" = SHRTCKN.SHRTCKN_PIDM
                  and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = SHRDGMR.SHRDGMR_SEQ_NO
                  and SHRTCKD.SHRTCKD_PIDM = SHRDGMR.SHRDGMR_PIDM
                  and SHRTCKN.SHRTCKN_CRN = SSRATTR2.SSRATTR_CRN
                  and SHRTCKN.SHRTCKN_TERM_CODE = SSRATTR2.SSRATTR_TERM_CODE )
            and ( ( SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                    and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                      FROM SHRTCKG
                      WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                      AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                      AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                    )
                    and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                    and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
                    and SSRATTR2.SSRATTR_ATTR_CODE ='CLIN' )
              and ( SHRTCKD_APPLIED_IND = 'Y' ) )
          group by SHRTCKD.SHRTCKD_PIDM ) trigger3
 where ( Query1."Campus" = STVCAMP.STVCAMP_CODE
         and Query1."PIDM" = trigger2."PIDM" (+)
         and Query1."PIDM" = trigger3."PIDM" (+) )
   and ( Query1."Faculty" =:ListBox_faculty.FacultyCode
         and ( :Para_DD_Status.Index =1
           and Query1."Times" >= 3
           or ( :Para_DD_Status.Index = 2
             and Query1."Times" = 2
             and NVL(trigger3."FailedCLINUnitCount",0) <= 1
             and nvl(trigger2."TotalFailedTime",0) <=2 )
           or ( :Para_DD_Status.Index = 3
             and Query1."Times" = 1
             and NVL(trigger3."FailedCLINUnitCount",0) = 0
             and nvl(trigger2."TotalFailedTime",0) <=1 ) )
         and ( :para_CB_allfdegr ='N'
           and Query1."DegreeCode" =:ListBox_degree.DegreeCode
           or ( :para_CB_allfdegr ='Y' ) )
         and ( :para_CB_allcampus2 ='N'
           and Query1."Campus" =:ListBox_Campus.DICCode
           or ( :para_CB_allcampus2 ='Y' ) ) )
union
select distinct :Para_DD_Year.YEAR||' '||:Para_DD_Review.Review_Period,
       :Para_DD_Status.status "Status",
       SPRIDEN1.SPRIDEN_ID "StudentID",
       SPRIDEN1.SPRIDEN_FIRST_NAME "FirstName",
       SPRIDEN1.SPRIDEN_LAST_NAME "LastName",
       SHRDGMR.SHRDGMR_COLL_CODE_1 "Faculty",
       STVCAMP.STVCAMP_DESC "Campus",
       SHRDGMR.SHRDGMR_DEGC_CODE "DegreeCode",
       CurrentDegree."DegSeq" "DegreeSeq",
       STVDEGS.STVDEGS_DESC "DegreeStatus",
       case when (select count(SGRSATT.SGRSATT_PIDM)
                  from SGRSATT
                  where SGRSATT.SGRSATT_PIDM = SPRIDEN1.SPRIDEN_PIDM
                   and SGRSATT.SGRSATT_ATTS_CODE in( 'EIP', 'EIPT')
                   and SGRSATT.SGRSATT_TERM_CODE_EFF = (SELECT MAX(A.SGRSATT_TERM_CODE_EFF)
                                                       FROM SGRSATT A
                                                       WHERE A.SGRSATT_PIDM = SGRSATT.SGRSATT_PIDM)) >='1'
       then 'Yes'
       else 'No'
       End "EIP",
       'Trigger 2' "Reason",
       (SELECT STVCITZ.STVCITZ_DESC
       FROM STVCITZ, SPBPERS
       WHERE SPBPERS.SPBPERS_PIDM = SPRIDEN1.SPRIDEN_PIDM
       AND STVCITZ.STVCITZ_CODE = SPBPERS.SPBPERS_CITZ_CODE) "Citizenship",
       (SELECT STVETHN.STVETHN_DESC
       FROM STVETHN, SPBPERS
       WHERE SPBPERS.SPBPERS_PIDM = SPRIDEN1.SPRIDEN_PIDM
       AND SPBPERS.SPBPERS_ETHN_CODE = STVETHN.STVETHN_CODE) "ATSI",
       ACU.SZKFUNC.GET_EMAIL_ADDRESS (SPRIDEN_ID, 'STDN') "StudentEmail",
       ACU.SZKFUNC.GET_EMAIL_ADDRESS (SPRIDEN_ID, 'PERS')  "PersonalEmail",
       ACU.SZKFUNC.GET_MOBILE_NUMBER (SPRIDEN_ID) "Mobile",
       (SELECT SPRADDR.SPRADDR_STREET_LINE1
          FROM SPRADDR
          WHERE SPRIDEN1.SPRIDEN_PIDM = SPRADDR.SPRADDR_PIDM
          AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
          AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
          AND SPRADDR.SPRADDR_TO_DATE is null
          AND SPRADDR.SPRADDR_STATUS_IND is null
       ) "StreetAddress1",
       (SELECT SPRADDR.SPRADDR_STREET_LINE2
          FROM SPRADDR
          WHERE SPRIDEN1.SPRIDEN_PIDM = SPRADDR.SPRADDR_PIDM
          AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
          AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
          AND SPRADDR.SPRADDR_TO_DATE is null
          AND SPRADDR.SPRADDR_STATUS_IND is null
          ) "StreetAddress2",
       (SELECT SPRADDR.SPRADDR_CITY
                      FROM SPRADDR
                      WHERE SPRIDEN1.SPRIDEN_PIDM = SPRADDR.SPRADDR_PIDM
                      AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
                      AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
                      AND SPRADDR.SPRADDR_TO_DATE is null
                      AND SPRADDR.SPRADDR_STATUS_IND is null
                     ) "City",
       (SELECT SPRADDR.SPRADDR_STAT_CODE
                      FROM SPRADDR
                      WHERE SPRIDEN1.SPRIDEN_PIDM = SPRADDR.SPRADDR_PIDM
                      AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
                      AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
                      AND SPRADDR.SPRADDR_TO_DATE is null
                      AND SPRADDR.SPRADDR_STATUS_IND is null
                     ) "State",
       (SELECT SPRADDR.SPRADDR_ZIP
          FROM SPRADDR
         WHERE SPRIDEN1.SPRIDEN_PIDM = SPRADDR.SPRADDR_PIDM
           AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
           AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
           AND SPRADDR.SPRADDR_TO_DATE is null
           AND SPRADDR.SPRADDR_STATUS_IND is null
         ) "Postcode",
       ( SELECT TO_CHAR(MAX(SHRTCKG.SHRTCKG_ACTIVITY_DATE),'DD/MM/YYYY')
           from SATURN.SHRTCKN SHRTCKN,
                SATURN.SHRTCKG SHRTCKG,
                SATURN.SHRTCKD SHRTCKD,
                SATURN.SHRDGMR SHRDGMR
         where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
             And SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+)
             and SHRTCKD.SHRTCKD_PIDM = SPRIDEN1.SPRIDEN_PIDM
             and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = CurrentDegree."DegSeq" )
             and SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
             and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
             and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                          FROM SHRTCKG
                                          WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                          AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                          AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO)
             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
             and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
             and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
             and ( (:Para_DD_Review.Index =1 and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82'))
                 or ( :Para_DD_Review.Index ='2' and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) )
       ) "LastFailedGradeDate",
       (SELECT LISTAGG(TO_CHAR(A.SPRCMNT_DATE,'DD/MM/YYYY')||','||A.SPRCMNT_CMTT_CODE||','||A.SPRCMNT_TEXT||';') WITHIN GROUP (ORDER BY A.SPRCMNT_ACTIVITY_DATE)
          FROM SPRCMNT A
         WHERE A.SPRCMNT_PIDM = SPRIDEN1.SPRIDEN_PIDM
           AND A.SPRCMNT_ACTIVITY_DATE >=( SELECT MAX(SHRTCKG.SHRTCKG_ACTIVITY_DATE)
                                             from SATURN.SHRTCKN SHRTCKN,
                                                  SATURN.SHRTCKG SHRTCKG,
                                                  SATURN.SHRTCKD SHRTCKD,
                                                  SATURN.SHRDGMR SHRDGMR
                                             where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                             And SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+)
                                             and SHRTCKD.SHRTCKD_PIDM = SPRIDEN1.SPRIDEN_PIDM
                                             and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = CurrentDegree."DegSeq"
                                             and SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                             and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                             and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                                                         FROM SHRTCKG
                                                                         WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                                         AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                                         AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO)
                                             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                             and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
                                             and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                                             and ( (:Para_DD_Review.Index =1 and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82'))
                                             or ( :Para_DD_Review.Index ='2' and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) )
       ))) "CommentText"
  from SATURN.SHRDGMR SHRDGMR,
       SATURN.STVCAMP STVCAMP,
       SATURN.SPRIDEN SPRIDEN1,
       SATURN.STVDEGS STVDEGS,
       ( select distinct FailedNONCLIN5."InternalId" "PIDM",
                FailedNONCLIN5."DegreeSeqNo" "DegSeq"
           from SATURN.SPRIDEN SPRIDEN,
                ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                         SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                         SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                         SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                         SPRIDEN.SPRIDEN_PIDM "InternalId",
                         SHRTCKN.SHRTCKN_SUBJ_CODE "SubjAreaCode",
                         SHRTCKN.SHRTCKN_CRSE_NUMB "CrseNo"
                    from SATURN.SPRIDEN SPRIDEN,
                         SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.SHRTCKD SHRTCKD
                   where ( SPRIDEN.SPRIDEN_PIDM = SHRTCKN.SHRTCKN_PIDM
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+) )
                     and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                             and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                             and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                               FROM SHRTCKG
                               WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                               AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                               AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                             )
                             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                             and SPRIDEN.SPRIDEN_ID NOT LIKE 'P%'
                             and (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                              FROM SSRATTR A
                              WHERE A.SSRATTR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                              AND A.SSRATTR_CRN = SHRTCKN.SHRTCKN_CRN
                              AND A.SSRATTR_ATTR_CODE = 'CLIN') =0
                             and ( :Para_DD_Review.Index =1
                               and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                               or ( :Para_DD_Review.Index ='2'
                                 and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                       and ( SPRIDEN_CHANGE_IND is null )
                       and ( SHRTCKD_APPLIED_IND = 'Y' ) ) ) FailedNONCLIN5
          where ( SPRIDEN.SPRIDEN_PIDM = FailedNONCLIN5."InternalId" )
            and ( SPRIDEN_CHANGE_IND is null ) ) CurrentDegree,
       ( select distinct AllDegreeFailedTimeCount2."InternalId" "PIDM",
                AllDegreeFailedTimeCount2."Unit" "Unit",
                Query11."TotalFailedTime" "TotalFailedTime"
           from ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                         SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                         SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                         SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB "Unit",
                         Count( SHRTCKN.SHRTCKN_TERM_CODE||SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB ) "FailedTimes",
                         SPRIDEN.SPRIDEN_PIDM "InternalId"
                    from SATURN.SPRIDEN SPRIDEN,
                         SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.SHRDGMR SHRDGMR1,
                         ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                                  SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                                  SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                                  SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                                  SPRIDEN.SPRIDEN_PIDM "InternalId",
                                  SHRTCKN.SHRTCKN_SUBJ_CODE "SubjAreaCode",
                                  SHRTCKN.SHRTCKN_CRSE_NUMB "CrseNo"
                             from SATURN.SPRIDEN SPRIDEN,
                                  SATURN.SHRTCKN SHRTCKN,
                                  SATURN.SHRTCKG SHRTCKG,
                                  SATURN.SHRTCKD SHRTCKD
                            where ( SPRIDEN.SPRIDEN_PIDM = SHRTCKN.SHRTCKN_PIDM
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+) )
                              and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                      and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                      and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                        FROM SHRTCKG
                                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                      )
                                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                      and SPRIDEN.SPRIDEN_ID NOT LIKE 'P%'
                                      and (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                       FROM SSRATTR A
                                       WHERE A.SSRATTR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                                       AND A.SSRATTR_CRN = SHRTCKN.SHRTCKN_CRN
                                       AND A.SSRATTR_ATTR_CODE = 'CLIN') =0
                                      and ( :Para_DD_Review.Index =1
                                        and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                        or ( :Para_DD_Review.Index ='2'
                                          and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                and ( SPRIDEN_CHANGE_IND is null )
                                and ( SHRTCKD_APPLIED_IND = 'Y' ) ) ) FailedNONCLIN4
                   where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SPRIDEN.SPRIDEN_PIDM = FailedNONCLIN4."InternalId"
                           and FailedNONCLIN4."InternalId" = SHRTCKN.SHRTCKN_PIDM
                           and FailedNONCLIN4."SubjAreaCode" = SHRTCKN.SHRTCKN_SUBJ_CODE
                           and FailedNONCLIN4."CrseNo" = SHRTCKN.SHRTCKN_CRSE_NUMB
                           and FailedNONCLIN4."InternalId" = SHRDGMR1.SHRDGMR_PIDM
                           and FailedNONCLIN4."DegreeSeqNo" = SHRDGMR1.SHRDGMR_SEQ_NO )
                     and ( ( SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                             and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                               FROM SHRTCKG
                               WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                               AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                               AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                             )
                             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                             and SHRDGMR1.SHRDGMR_DEGS_CODE <>'AH' )
                       and ( SPRIDEN_CHANGE_IND is null ) )
                   group by SPRIDEN.SPRIDEN_ID,
                            SPRIDEN.SPRIDEN_FIRST_NAME,
                            SPRIDEN.SPRIDEN_LAST_NAME,
                            SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB,
                            SPRIDEN.SPRIDEN_PIDM ) AllDegreeFailedTimeCount2,
                ( select distinct AllDegreeFailedTimeCount11."InternalId" "PIDM",
                         Max( AllDegreeFailedTimeCount11."FailedTimes" + nvl(EqiFailedTimes1."FailedEqiUnitTerrm",0) ) "TotalFailedTime"
                    from ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                                  SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                                  SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                                  SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB "Unit",
                                  Count( SHRTCKN.SHRTCKN_TERM_CODE||SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB ) "FailedTimes",
                                  SPRIDEN.SPRIDEN_PIDM "InternalId"
                             from SATURN.SPRIDEN SPRIDEN,
                                  SATURN.SHRTCKN SHRTCKN,
                                  SATURN.SHRTCKG SHRTCKG,
                                  SATURN.SHRDGMR SHRDGMR1,
                                  ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                                           SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                                           SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                                           SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                                           SPRIDEN.SPRIDEN_PIDM "InternalId",
                                           SHRTCKN.SHRTCKN_SUBJ_CODE "SubjAreaCode",
                                           SHRTCKN.SHRTCKN_CRSE_NUMB "CrseNo"
                                      from SATURN.SPRIDEN SPRIDEN,
                                           SATURN.SHRTCKN SHRTCKN,
                                           SATURN.SHRTCKG SHRTCKG,
                                           SATURN.SHRTCKD SHRTCKD
                                     where ( SPRIDEN.SPRIDEN_PIDM = SHRTCKN.SHRTCKN_PIDM
                                             and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                             and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+) )
                                       and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                               and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                               and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                                 FROM SHRTCKG
                                                 WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                 AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                 AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                               )
                                               and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                               and SPRIDEN.SPRIDEN_ID NOT LIKE 'P%'
                                               and (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                                FROM SSRATTR A
                                                WHERE A.SSRATTR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                                                AND A.SSRATTR_CRN = SHRTCKN.SHRTCKN_CRN
                                                AND A.SSRATTR_ATTR_CODE = 'CLIN') =0
                                               and ( :Para_DD_Review.Index =1
                                                 and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                                 or ( :Para_DD_Review.Index ='2'
                                                   and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                         and ( SPRIDEN_CHANGE_IND is null )
                                         and ( SHRTCKD_APPLIED_IND = 'Y' ) ) ) FailedNONCLIN2
                            where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                    and SPRIDEN.SPRIDEN_PIDM = FailedNONCLIN2."InternalId"
                                    and FailedNONCLIN2."InternalId" = SHRTCKN.SHRTCKN_PIDM
                                    and FailedNONCLIN2."SubjAreaCode" = SHRTCKN.SHRTCKN_SUBJ_CODE
                                    and FailedNONCLIN2."CrseNo" = SHRTCKN.SHRTCKN_CRSE_NUMB
                                    and FailedNONCLIN2."InternalId" = SHRDGMR1.SHRDGMR_PIDM
                                    and FailedNONCLIN2."DegreeSeqNo" = SHRDGMR1.SHRDGMR_SEQ_NO )
                              and ( ( SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                        FROM SHRTCKG
                                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                      )
                                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                      and SHRDGMR1.SHRDGMR_DEGS_CODE <>'AH'
                                      and ( :Para_DD_Review.Index =1
                                        and SHRTCKN.SHRTCKN_TERM_CODE <=:Para_DD_Year.YEAR*100+47
                                        and SHRTCKN.SHRTCKN_TERM_CODE <>:Para_DD_Year.YEAR*100+45
                                        or ( :Para_DD_Review.Index =2
                                          and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97 ) ) )
                                and ( SPRIDEN_CHANGE_IND is null ) )
                            group by SPRIDEN.SPRIDEN_ID,
                                     SPRIDEN.SPRIDEN_FIRST_NAME,
                                     SPRIDEN.SPRIDEN_LAST_NAME,
                                     SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB,
                                     SPRIDEN.SPRIDEN_PIDM ) AllDegreeFailedTimeCount11,
                         ( select distinct SPRIDEN.SPRIDEN_PIDM "InternalId",
                                  Count( SHRTCKN.SHRTCKN_TERM_CODE||Query."EqivSub"||Query."EqivCrsNo" ) "FailedEqiUnitTerrm",
                                  Query."SubjectCode"||Query."CrseNo" "FailedUnit"
                             from SATURN.SPRIDEN SPRIDEN,
                                  SATURN.SHRTCKN SHRTCKN,
                                  SATURN.SHRTCKG SHRTCKG,
                                  SATURN.SHRTCKD SHRTCKD,
                                  SATURN.SHRDGMR SHRDGMR,
                                  ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                                           SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                                           SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                                           SHRTCKN.SHRTCKN_TERM_CODE "Term",
                                           SHRTCKN.SHRTCKN_CRN "CRN",
                                           SHRTCKG.SHRTCKG_GRDE_CODE_FINAL "Grade",
                                           SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                                           (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                            FROM SSRATTR A
                                            WHERE A.SSRATTR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                                            AND A.SSRATTR_CRN = SHRTCKN.SHRTCKN_CRN
                                            AND A.SSRATTR_ATTR_CODE = 'CLIN') "CLIN",
                                           SPRIDEN.SPRIDEN_PIDM "InternalId",
                                           SHRTCKN.SHRTCKN_SUBJ_CODE "SubjAreaCode",
                                           SHRTCKN.SHRTCKN_CRSE_NUMB "CrseNo"
                                      from SATURN.SPRIDEN SPRIDEN,
                                           SATURN.SHRTCKN SHRTCKN,
                                           SATURN.SHRTCKG SHRTCKG,
                                           SATURN.SHRTCKD SHRTCKD
                                     where ( SPRIDEN.SPRIDEN_PIDM = SHRTCKN.SHRTCKN_PIDM
                                             and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                             and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+) )
                                       and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                               and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                               and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                                 FROM SHRTCKG
                                                 WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                 AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                 AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                               )
                                               and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                               and SPRIDEN.SPRIDEN_ID NOT LIKE 'P%'
                                               and (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                                FROM SSRATTR A
                                                WHERE A.SSRATTR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                                                AND A.SSRATTR_CRN = SHRTCKN.SHRTCKN_CRN
                                                AND A.SSRATTR_ATTR_CODE = 'CLIN') =0
                                               and ( :Para_DD_Review.Index =1
                                                 and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                                 or ( :Para_DD_Review.Index ='2'
                                                   and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                         and ( SPRIDEN_CHANGE_IND is null )
                                         and ( SHRTCKD_APPLIED_IND = 'Y' ) )
                                     order by SPRIDEN.SPRIDEN_ID,
                                              SHRTCKN.SHRTCKN_TERM_CODE ) FailedNONCLIN1,
                                  ( select distinct SSBSECT2.SSBSECT_TERM_CODE "Term",
                                           SSBSECT2.SSBSECT_CRN "CRN",
                                           SSBSECT2.SSBSECT_SUBJ_CODE "SubjectCode",
                                           SSBSECT2.SSBSECT_CRSE_NUMB "CrseNo",
                                           SCREQIV1.SCREQIV_SUBJ_CODE_EQIV "EqivSub",
                                           SCREQIV1.SCREQIV_CRSE_NUMB_EQIV "EqivCrsNo"
                                      from SATURN.SSBSECT SSBSECT2,
                                           SATURN.SCREQIV SCREQIV1
                                     where ( SSBSECT2.SSBSECT_SUBJ_CODE = SCREQIV1.SCREQIV_SUBJ_CODE
                                             and SSBSECT2.SSBSECT_CRSE_NUMB = SCREQIV1.SCREQIV_CRSE_NUMB )
                                       and ( SSBSECT2.SSBSECT_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                             and SSBSECT2.SSBSECT_TERM_CODE < :Para_DD_Year.YEAR *100 + 97
                                             and SCREQIV1.SCREQIV_END_TERM >=SSBSECT2.SSBSECT_TERM_CODE
                                             and SCREQIV1.SCREQIV_EFF_TERM <=SSBSECT2.SSBSECT_TERM_CODE
                                             and (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                              FROM SSRATTR A
                                              WHERE A.SSRATTR_TERM_CODE = SSBSECT2.SSBSECT_TERM_CODE
                                              AND A.SSRATTR_CRN = SSBSECT2.SSBSECT_CRN
                                              AND A.SSRATTR_ATTR_CODE = 'CLIN') =0
                                             and ( :Para_DD_Review.Index =1
                                               and SUBSTR(SSBSECT2.SSBSECT_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                               or ( :Para_DD_Review.Index =2
                                                 and SUBSTR(SSBSECT2.SSBSECT_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                     order by 1,
                                              3 ) Query
                            where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO
                                    and SPRIDEN.SPRIDEN_PIDM = FailedNONCLIN1."InternalId"
                                    and Query."EqivSub" = SHRTCKN.SHRTCKN_SUBJ_CODE
                                    and Query."EqivCrsNo" = SHRTCKN.SHRTCKN_CRSE_NUMB
                                    and FailedNONCLIN1."InternalId" = SHRDGMR.SHRDGMR_PIDM
                                    and FailedNONCLIN1."DegreeSeqNo" = SHRDGMR.SHRDGMR_SEQ_NO
                                    and FailedNONCLIN1."Term" = Query."Term"
                                    and FailedNONCLIN1."CRN" = Query."CRN"
                                    and FailedNONCLIN1."InternalId" = SHRTCKD.SHRTCKD_PIDM )
                              and ( ( SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                      and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                        FROM SHRTCKG
                                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                      )
                                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                      and SHRTCKN.SHRTCKN_TERM_CODE <=Query."Term"
                                      and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH' )
                                and ( SPRIDEN_CHANGE_IND is null )
                                and ( SHRTCKD_APPLIED_IND = 'Y' ) )
                            group by SPRIDEN.SPRIDEN_PIDM,
                                     Query."SubjectCode"||Query."CrseNo" ) EqiFailedTimes1
                   where ( AllDegreeFailedTimeCount11."InternalId" = EqiFailedTimes1."InternalId" (+)
                           and AllDegreeFailedTimeCount11."Unit" = EqiFailedTimes1."FailedUnit" (+) )
                   group by AllDegreeFailedTimeCount11."InternalId"
                  having :Para_DD_Status.Index = 1 and Max( AllDegreeFailedTimeCount11."FailedTimes" + nvl(EqiFailedTimes1."FailedEqiUnitTerrm",0) ) >= 3
                         or ( :Para_DD_Status.Index = 2 and Max( AllDegreeFailedTimeCount11."FailedTimes" + nvl(EqiFailedTimes1."FailedEqiUnitTerrm",0) ) = 2 ) ) Query11,
                ( select distinct SPRIDEN.SPRIDEN_PIDM "InternalId",
                         Count( SHRTCKN.SHRTCKN_TERM_CODE||Query."EqivSub"||Query."EqivCrsNo" ) "FailedEqiUnitTerrm",
                         Query."SubjectCode"||Query."CrseNo" "FailedUnit"
                    from SATURN.SPRIDEN SPRIDEN,
                         SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.SHRTCKD SHRTCKD,
                         SATURN.SHRDGMR SHRDGMR,
                         ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                                  SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                                  SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                                  SHRTCKN.SHRTCKN_TERM_CODE "Term",
                                  SHRTCKN.SHRTCKN_CRN "CRN",
                                  SHRTCKG.SHRTCKG_GRDE_CODE_FINAL "Grade",
                                  SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                                  (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                   FROM SSRATTR A
                                   WHERE A.SSRATTR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                                   AND A.SSRATTR_CRN = SHRTCKN.SHRTCKN_CRN
                                   AND A.SSRATTR_ATTR_CODE = 'CLIN') "CLIN",
                                  SPRIDEN.SPRIDEN_PIDM "InternalId",
                                  SHRTCKN.SHRTCKN_SUBJ_CODE "SubjAreaCode",
                                  SHRTCKN.SHRTCKN_CRSE_NUMB "CrseNo"
                             from SATURN.SPRIDEN SPRIDEN,
                                  SATURN.SHRTCKN SHRTCKN,
                                  SATURN.SHRTCKG SHRTCKG,
                                  SATURN.SHRTCKD SHRTCKD
                            where ( SPRIDEN.SPRIDEN_PIDM = SHRTCKN.SHRTCKN_PIDM
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+) )
                              and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                      and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                      and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                        FROM SHRTCKG
                                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                      )
                                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                      and SPRIDEN.SPRIDEN_ID NOT LIKE 'P%'
                                      and (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                       FROM SSRATTR A
                                       WHERE A.SSRATTR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                                       AND A.SSRATTR_CRN = SHRTCKN.SHRTCKN_CRN
                                       AND A.SSRATTR_ATTR_CODE = 'CLIN') =0
                                      and ( :Para_DD_Review.Index =1
                                        and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                        or ( :Para_DD_Review.Index ='2'
                                          and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                and ( SPRIDEN_CHANGE_IND is null )
                                and ( SHRTCKD_APPLIED_IND = 'Y' ) )
                            order by SPRIDEN.SPRIDEN_ID,
                                     SHRTCKN.SHRTCKN_TERM_CODE ) FailedNONCLIN3,
                         ( select distinct SSBSECT2.SSBSECT_TERM_CODE "Term",
                                  SSBSECT2.SSBSECT_CRN "CRN",
                                  SSBSECT2.SSBSECT_SUBJ_CODE "SubjectCode",
                                  SSBSECT2.SSBSECT_CRSE_NUMB "CrseNo",
                                  SCREQIV1.SCREQIV_SUBJ_CODE_EQIV "EqivSub",
                                  SCREQIV1.SCREQIV_CRSE_NUMB_EQIV "EqivCrsNo"
                             from SATURN.SSBSECT SSBSECT2,
                                  SATURN.SCREQIV SCREQIV1
                            where ( SSBSECT2.SSBSECT_SUBJ_CODE = SCREQIV1.SCREQIV_SUBJ_CODE
                                    and SSBSECT2.SSBSECT_CRSE_NUMB = SCREQIV1.SCREQIV_CRSE_NUMB )
                              and ( SSBSECT2.SSBSECT_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                    and SSBSECT2.SSBSECT_TERM_CODE < :Para_DD_Year.YEAR *100 + 97
                                    and SCREQIV1.SCREQIV_END_TERM >=SSBSECT2.SSBSECT_TERM_CODE
                                    and SCREQIV1.SCREQIV_EFF_TERM <=SSBSECT2.SSBSECT_TERM_CODE
                                    and (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                     FROM SSRATTR A
                                     WHERE A.SSRATTR_TERM_CODE = SSBSECT2.SSBSECT_TERM_CODE
                                     AND A.SSRATTR_CRN = SSBSECT2.SSBSECT_CRN
                                     AND A.SSRATTR_ATTR_CODE = 'CLIN') =0
                                    and ( :Para_DD_Review.Index =1
                                      and SUBSTR(SSBSECT2.SSBSECT_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                      or ( :Para_DD_Review.Index =2
                                        and SUBSTR(SSBSECT2.SSBSECT_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                            order by 1,
                                     3 ) Query
                   where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO
                           and SPRIDEN.SPRIDEN_PIDM = FailedNONCLIN3."InternalId"
                           and Query."EqivSub" = SHRTCKN.SHRTCKN_SUBJ_CODE
                           and Query."EqivCrsNo" = SHRTCKN.SHRTCKN_CRSE_NUMB
                           and FailedNONCLIN3."InternalId" = SHRDGMR.SHRDGMR_PIDM
                           and FailedNONCLIN3."DegreeSeqNo" = SHRDGMR.SHRDGMR_SEQ_NO
                           and FailedNONCLIN3."Term" = Query."Term"
                           and FailedNONCLIN3."CRN" = Query."CRN"
                           and FailedNONCLIN3."InternalId" = SHRTCKD.SHRTCKD_PIDM )
                     and ( ( SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                             and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                               FROM SHRTCKG
                               WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                               AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                               AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                             )
                             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                             and SHRTCKN.SHRTCKN_TERM_CODE <=Query."Term"
                             and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH' )
                       and ( SPRIDEN_CHANGE_IND is null )
                       and ( SHRTCKD_APPLIED_IND = 'Y' ) )
                   group by SPRIDEN.SPRIDEN_PIDM,
                            Query."SubjectCode"||Query."CrseNo" ) EqiFailedTimes2
          where ( AllDegreeFailedTimeCount2."InternalId" = EqiFailedTimes2."InternalId" (+)
                  and AllDegreeFailedTimeCount2."Unit" = EqiFailedTimes2."FailedUnit" (+)
                  and AllDegreeFailedTimeCount2."InternalId" = Query11."PIDM" )
            and ( ( AllDegreeFailedTimeCount2."FailedTimes" + nvl(EqiFailedTimes2."FailedEqiUnitTerrm",0) ) =Query11."TotalFailedTime" ) ) MaxFailedTime,
       ( select distinct datascope11."InternalId" "PIDM",
                Count( FailedUnit1."InternalId" ) "Times"
           from ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                         TotalUnit21."DegreeSeqNo" "DegreeSeq",
                         SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                         SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                         ROUND(FailedUnitCount1."CreditHours"/(DECODE((NVL(TotalUnit21."TotalCP",0) + NVL(BlankUnitCount."CreditHours",0)),0,1,(NVL(TotalUnit21."TotalCP",0) + NVL(BlankUnitCount."CreditHours",0)))),2)*100 "PctFailedCP",
                         ROUND(FailedUnitCount1."Unit"/(DECODE((NVL(TotalUnit21."ToatlUnitCount",0) + NVL(BlankUnitCount."Count",0)),0,1,(NVL(TotalUnit21."ToatlUnitCount",0) + NVL(BlankUnitCount."Count",0)))),2)*100 "PctFailedUnit",
                         (select  listagg(SGRSATT.SGRSATT_TERM_CODE_EFF|| ', ') within group (order by SGRSATT.SGRSATT_PIDM)
                                 from sgrsatt
                                 where SGRSATT.SGRSATT_PIDM = SPRIDEN.SPRIDEN_PIDM
                                  and SGRSATT.SGRSATT_ATTS_CODE = 'SHCA'
                                  and SGRSATT.SGRSATT_TERM_CODE_EFF > (SELECT MIN(A.SHRTCKD_TERM_CODE)
                                                                       FROM SHRTCKD A
                                                                       WHERE A.SHRTCKD_PIDM = FailedUnitCount1."InternalId"
                                                                       AND A.SHRTCKD_DGMR_SEQ_NO = TotalUnit21."DegreeSeqNo"
                                                                       AND A.SHRTCKD_APPLIED_IND ='Y')
                                  group by SGRSATT.SGRSATT_PIDM) "SHCA",
                         SPRIDEN.SPRIDEN_PIDM "InternalId"
                    from SATURN.SPRIDEN SPRIDEN,
                         ( select distinct SHRTCKN.SHRTCKN_PIDM "PIDM",
                                  Count( SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB ) "ToatlUnitCount",
                                  Sum( SHRTCKG.SHRTCKG_CREDIT_HOURS ) "TotalCP",
                                  SHRDGMR.SHRDGMR_SEQ_NO "DegreeSeqNo"
                             from SATURN.SHRTCKN SHRTCKN,
                                  SATURN.SHRTCKG SHRTCKG,
                                  SATURN.SHRTCKD SHRTCKD,
                                  SATURN.SHRDGMR SHRDGMR
                            where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+)
                                    and SHRTCKD.SHRTCKD_PIDM = SHRDGMR.SHRDGMR_PIDM
                                    and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = SHRDGMR.SHRDGMR_SEQ_NO )
                              and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                      and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                      and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                        FROM SHRTCKG
                                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                      )
                                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('HD', 'DI', 'CR', 'PA', 'PX', 'NN', 'NH', 'NU', 'WN','PS','IP',
                                      'NF',
                                      'RP',
                                      'DE',
                                      'RW',
                                      'CU',
                                      'CE',
                                      'NL')
                                      and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
                                      and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                                      and ( :Para_DD_Review.Index =1
                                        and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                        or ( :Para_DD_Review.Index ='2'
                                          and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                and ( SHRTCKD_APPLIED_IND = 'Y' ) )
                            group by SHRTCKN.SHRTCKN_PIDM,
                                     SHRDGMR.SHRDGMR_SEQ_NO
                            order by SHRTCKN.SHRTCKN_TERM_CODE ) TotalUnit21,
                         ( select distinct SHRTCKN.SHRTCKN_PIDM "InternalId",
                                  Count( SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB ) "Unit",
                                  Sum( SHRTCKG.SHRTCKG_CREDIT_HOURS ) "CreditHours",
                                  SHRDGMR.SHRDGMR_SEQ_NO "DegreeSeqNo"
                             from SATURN.SHRTCKN SHRTCKN,
                                  SATURN.SHRTCKG SHRTCKG,
                                  SATURN.SHRTCKD SHRTCKD,
                                  SATURN.SHRDGMR SHRDGMR
                            where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+)
                                    and SHRTCKD.SHRTCKD_PIDM = SHRDGMR.SHRDGMR_PIDM
                                    and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = SHRDGMR.SHRDGMR_SEQ_NO )
                              and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                      and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                      and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                        FROM SHRTCKG
                                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                      )
                                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                      and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
                                      and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                                      and ( :Para_DD_Review.Index =1
                                        and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                        or ( :Para_DD_Review.Index ='2'
                                          and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                and ( SHRTCKD_APPLIED_IND = 'Y' ) )
                            group by SHRTCKN.SHRTCKN_PIDM,
                                     SHRDGMR.SHRDGMR_SEQ_NO
                            order by SHRTCKN.SHRTCKN_TERM_CODE ) FailedUnitCount1,
                         ( select distinct SFRSTCR.SFRSTCR_PIDM "PIDM",
                                  Count( SFRSTCR.SFRSTCR_PIDM ) "Count",
                                  Sum( SFRSTCR.SFRSTCR_CREDIT_HR ) "CreditHours"
                             from SATURN.SFRSTCR SFRSTCR,
                                  SATURN.SHRTCKN SHRTCKN
                            where ( SFRSTCR.SFRSTCR_PIDM = SHRTCKN.SHRTCKN_PIDM (+)
                                    and SFRSTCR.SFRSTCR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE (+)
                                    and SFRSTCR.SFRSTCR_CRN = SHRTCKN.SHRTCKN_CRN (+) )
                              and ( SFRSTCR.SFRSTCR_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                    and SFRSTCR.SFRSTCR_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                    and SFRSTCR.SFRSTCR_GRDE_CODE is null
                                    and (SELECT SHRTCKG.SHRTCKG_GRDE_CODE_FINAL
                                                            FROM SHRTCKG
                                                           WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                             AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                             AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                                             AND SHRTCKG.SHRTCKG_SEQ_NO = (SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                                                                             FROM SHRTCKG
                                                                                            WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                                                             AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                                                             AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                                                                    )) is null
                                    and SFRSTCR.SFRSTCR_RSTS_CODE IN ('RE','RW','DF','DN','DP')
                                    and ( :Para_DD_Review.Index =1
                                      and SUBSTR(SFRSTCR.SFRSTCR_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                      or ( :Para_DD_Review.Index ='2'
                                        and SUBSTR(SFRSTCR.SFRSTCR_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                            group by SFRSTCR.SFRSTCR_PIDM
                            order by SFRSTCR.SFRSTCR_PIDM ) BlankUnitCount
                   where ( SPRIDEN.SPRIDEN_PIDM = TotalUnit21."PIDM"
                           and TotalUnit21."PIDM" = FailedUnitCount1."InternalId" (+)
                           and TotalUnit21."DegreeSeqNo" = FailedUnitCount1."DegreeSeqNo" (+)
                           and SPRIDEN.SPRIDEN_PIDM = BlankUnitCount."PIDM" (+) )
                     and ( ( SPRIDEN.SPRIDEN_ID NOT LIKE 'P%'
                             and ( ROUND(FailedUnitCount1."CreditHours"/(DECODE((NVL(TotalUnit21."TotalCP",0) + NVL(BlankUnitCount."CreditHours",0)),0,1,(NVL(TotalUnit21."TotalCP",0) + NVL(BlankUnitCount."CreditHours",0)))),2)*100 >=50
                               or ROUND(FailedUnitCount1."Unit"/(DECODE((NVL(TotalUnit21."ToatlUnitCount",0) + NVL(BlankUnitCount."Count",0)),0,1,(NVL(TotalUnit21."ToatlUnitCount",0) + NVL(BlankUnitCount."Count",0)))),2)*100 >=50 ) )
                       and ( SPRIDEN_CHANGE_IND is null ) ) ) datascope11,
                ( select distinct SHRTCKD.SHRTCKD_PIDM "InternalId",
                         SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                         CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) ='97'
                              THEN TO_CHAR(STVTERM.STVTERM_ACYR_CODE + 1)
                              ELSE STVTERM.STVTERM_ACYR_CODE
                         END "ReviewYear",
                         CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                         THEN '1'
                         ELSE CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2)  IN ('45','55','60','65','70','56','76','86','87')
                              THEN '2'
                              END
                         END "ReviewPeriod",
                         Sum( SHRTCKG.SHRTCKG_CREDIT_HOURS ) "TotalGreditHours",
                         Count( SHRTCKN.SHRTCKN_CRN ) "TotalUnitCount"
                    from SATURN.SHRTCKD SHRTCKD,
                         SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.STVTERM STVTERM
                   where ( SHRTCKD.SHRTCKD_PIDM = SHRTCKN.SHRTCKN_PIDM
                           and SHRTCKD.SHRTCKD_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                           and SHRTCKD.SHRTCKD_TCKN_SEQ_NO = SHRTCKN.SHRTCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SHRTCKD.SHRTCKD_TERM_CODE = STVTERM.STVTERM_CODE )
                     and ( SHRTCKG.SHRTCKG_SEQ_NO = (SELECT MAX(A.SHRTCKG_SEQ_NO)
                             FROM SHRTCKG A
                             WHERE A.SHRTCKG_PIDM = SHRTCKG.SHRTCKG_PIDM
                             AND A.SHRTCKG_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                             AND A.SHRTCKG_TCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO)
                           and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                           and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL') )
                   group by SHRTCKD.SHRTCKD_PIDM,
                            SHRTCKD.SHRTCKD_DGMR_SEQ_NO,
                            CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) ='97'
                       THEN TO_CHAR(STVTERM.STVTERM_ACYR_CODE + 1)
                       ELSE STVTERM.STVTERM_ACYR_CODE
                  END,
                            CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                  THEN '1'
                  ELSE CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2)  IN ('45','55','60','65','70','56','76','86','87')
                       THEN '2'
                       END
                  END ) FailedUnit1,
                ( select distinct SHRTCKD.SHRTCKD_PIDM "InternalId",
                         SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                         CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) ='97'
                              THEN TO_CHAR(STVTERM.STVTERM_ACYR_CODE + 1)
                              ELSE STVTERM.STVTERM_ACYR_CODE
                         END "ReviewYear",
                         CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                         THEN '1'
                         ELSE CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2)  IN ('45','55','60','65','70','56','76','86','87')
                              THEN '2'
                              END
                         END "ReviewPeriod",
                         Sum( SHRTCKG.SHRTCKG_CREDIT_HOURS ) "TotalGreditHours",
                         Count( SHRTCKN.SHRTCKN_CRN ) "TotalUnitCount"
                    from SATURN.SHRTCKD SHRTCKD,
                         SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.STVTERM STVTERM
                   where ( SHRTCKD.SHRTCKD_PIDM = SHRTCKN.SHRTCKN_PIDM
                           and SHRTCKD.SHRTCKD_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                           and SHRTCKD.SHRTCKD_TCKN_SEQ_NO = SHRTCKN.SHRTCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SHRTCKD.SHRTCKD_TERM_CODE = STVTERM.STVTERM_CODE )
                     and ( SHRTCKG.SHRTCKG_SEQ_NO = (SELECT MAX(A.SHRTCKG_SEQ_NO)
                             FROM SHRTCKG A
                             WHERE A.SHRTCKG_PIDM = SHRTCKG.SHRTCKG_PIDM
                             AND A.SHRTCKG_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                             AND A.SHRTCKG_TCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO)
                           and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                           and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('HD', 'DI', 'CR', 'PA', 'PX', 'NN', 'NH', 'NU', 'WN','PS','IP',
                           'NF',
                           'RP',
                           'DE',
                           'RW',
                           'CU',
                           'CE','NL') )
                   group by SHRTCKD.SHRTCKD_PIDM,
                            SHRTCKD.SHRTCKD_DGMR_SEQ_NO,
                            CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) ='97'
                       THEN TO_CHAR(STVTERM.STVTERM_ACYR_CODE + 1)
                       ELSE STVTERM.STVTERM_ACYR_CODE
                  END,
                            CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                  THEN '1'
                  ELSE CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2)  IN ('45','55','60','65','70','56','76','86','87')
                       THEN '2'
                       END
                  END ) TotalUnit11,
                ( select distinct SFRSTCR.SFRSTCR_PIDM "PIDM",
                         Count( SFRSTCR.SFRSTCR_PIDM ) "Count",
                         Sum( SFRSTCR.SFRSTCR_CREDIT_HR ) "CreditHours"
                    from SATURN.SFRSTCR SFRSTCR,
                         SATURN.SHRTCKN SHRTCKN
                   where ( SFRSTCR.SFRSTCR_PIDM = SHRTCKN.SHRTCKN_PIDM (+)
                           and SFRSTCR.SFRSTCR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE (+)
                           and SFRSTCR.SFRSTCR_CRN = SHRTCKN.SHRTCKN_CRN (+) )
                     and ( SFRSTCR.SFRSTCR_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                           and SFRSTCR.SFRSTCR_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                           and SFRSTCR.SFRSTCR_GRDE_CODE is null
                           and (SELECT SHRTCKG.SHRTCKG_GRDE_CODE_FINAL
                                                   FROM SHRTCKG
                                                  WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                    AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                    AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                                    AND SHRTCKG.SHRTCKG_SEQ_NO = (SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                                                                    FROM SHRTCKG
                                                                                   WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                                                    AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                                                    AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                                                           )) is null
                           and SFRSTCR.SFRSTCR_RSTS_CODE IN ('RE','RW','DF','DN','DP')
                           and ( :Para_DD_Review.Index =1
                             and SUBSTR(SFRSTCR.SFRSTCR_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                             or ( :Para_DD_Review.Index ='2'
                               and SUBSTR(SFRSTCR.SFRSTCR_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                   group by SFRSTCR.SFRSTCR_PIDM
                   order by SFRSTCR.SFRSTCR_PIDM ) BlankUnit2
          where ( TotalUnit11."InternalId" = FailedUnit1."InternalId" (+)
                  and TotalUnit11."DegreeSeqNo" = FailedUnit1."DegreeSeqNo" (+)
                  and TotalUnit11."ReviewYear" = FailedUnit1."ReviewYear" (+)
                  and TotalUnit11."ReviewPeriod" = FailedUnit1."ReviewPeriod" (+)
                  and datascope11."InternalId" = TotalUnit11."InternalId"
                  and datascope11."DegreeSeq" = TotalUnit11."DegreeSeqNo"
                  and datascope11."InternalId" = BlankUnit2."PIDM" (+) )
            and ( datascope11."ID" not like 'P%'
                  and ( ROUND(FailedUnit1."TotalGreditHours"/(DECODE((NVL(TotalUnit11."TotalGreditHours",0) + NVL(BlankUnit2."CreditHours",0)),0,1,(NVL(TotalUnit11."TotalGreditHours",0) + NVL(BlankUnit2."CreditHours",0)))),2)*100 >= 50
                    or ROUND(FailedUnit1."TotalUnitCount"/(DECODE((NVL(TotalUnit11."TotalUnitCount",0) + NVL(BlankUnit2."Count",0)),0,1,(NVL(TotalUnit11."TotalUnitCount",0) + NVL(BlankUnit2."Count",0)))),2)*100 >= 50 ) )
          group by datascope11."InternalId" ) trigger1
 where ( CurrentDegree."PIDM" = SHRDGMR.SHRDGMR_PIDM
         and CurrentDegree."DegSeq" = SHRDGMR.SHRDGMR_SEQ_NO
         and SHRDGMR.SHRDGMR_CAMP_CODE = STVCAMP.STVCAMP_CODE
         and SHRDGMR.SHRDGMR_PIDM = SPRIDEN1.SPRIDEN_PIDM
         and SPRIDEN1.SPRIDEN_PIDM = MaxFailedTime."PIDM"
         and SHRDGMR.SHRDGMR_DEGS_CODE = STVDEGS.STVDEGS_CODE (+)
         and SPRIDEN1.SPRIDEN_PIDM = trigger1."PIDM" (+) )
   and ( SHRDGMR.SHRDGMR_COLL_CODE_1 =:ListBox_faculty.FacultyCode
         and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
         and SPRIDEN1.SPRIDEN_CHANGE_IND IS NULL
         and SHRDGMR.SHRDGMR_SEQ_NO in (
         SELECT DISTINCT A.SHRTCKD_DGMR_SEQ_NO
         FROM SHRTCKD A,
              SHRTCKN B
         WHERE B.SHRTCKN_PIDM = CurrentDegree."PIDM"
         AND B.SHRTCKN_SUBJ_CODE||B.SHRTCKN_CRSE_NUMB = MaxFailedTime."Unit"
         AND B.SHRTCKN_TERM_CODE = A.SHRTCKD_TERM_CODE
         AND B.SHRTCKN_SEQ_NO = A.SHRTCKD_TCKN_SEQ_NO
         AND A.SHRTCKD_PIDM = B.SHRTCKN_PIDM
         AND A.SHRTCKD_APPLIED_IND = 'Y')
         and ( SHRDGMR.SHRDGMR_DEGC_CODE =:ListBox_degree.DegreeCode
           and :para_CB_allfdegr ='N'
           or ( :para_CB_allfdegr ='Y' ) )
         and ( :para_CB_allcampus2 ='N'
           and SHRDGMR.SHRDGMR_CAMP_CODE = :ListBox_Campus.DICCode
           or ( :para_CB_allcampus2 ='Y' ) )
         and ( :Para_DD_Status.Index = 2
           and NVL((select distinct Count( SHRTCKN.SHRTCKN_TERM_CODE||SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB )
             from SATURN.SHRTCKN SHRTCKN,
                  SATURN.SHRTCKG SHRTCKG,
                  SATURN.SHRTCKD SHRTCKD,
                  SATURN.SHRDGMR SHRDGMR,
                  SATURN.SSRATTR SSRATTR2,
                  ( select distinct SHRTCKN.SHRTCKN_PIDM "PIDM",
                           SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                           SHRTCKN.SHRTCKN_SUBJ_CODE "SubjAreaCode",
                           SHRTCKN.SHRTCKN_CRSE_NUMB "CrseNo"
                      from SATURN.SHRTCKN SHRTCKN,
                           SATURN.SHRTCKG SHRTCKG,
                           SATURN.SHRTCKD SHRTCKD,
                           SATURN.SSRATTR SSRATTR,
                           SATURN.SHRDGMR SHRDGMR1
                     where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                             and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM
                             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE
                             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO
                             and SHRTCKN.SHRTCKN_TERM_CODE = SSRATTR.SSRATTR_TERM_CODE
                             and SHRTCKN.SHRTCKN_CRN = SSRATTR.SSRATTR_CRN
                             and SHRTCKD.SHRTCKD_PIDM = SHRDGMR1.SHRDGMR_PIDM
                             and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = SHRDGMR1.SHRDGMR_SEQ_NO )
                       and ( ( SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                 FROM SHRTCKG
                                 WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                 AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                 AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                               )
                               and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                               and SSRATTR.SSRATTR_ATTR_CODE ='CLIN'
                               and SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                               and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                               and SHRDGMR1.SHRDGMR_DEGS_CODE <>'AH'
                               and ( :Para_DD_Review.Index =1
                                 and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                 or ( :Para_DD_Review.Index ='2'
                                   and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                         and ( SHRTCKD_APPLIED_IND = 'Y' ) ) ) FailedCLIN
            where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM
                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE
                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO
                    and FailedCLIN."PIDM" = SHRTCKN.SHRTCKN_PIDM
                    and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = SHRDGMR.SHRDGMR_SEQ_NO
                    and SHRTCKD.SHRTCKD_PIDM = SHRDGMR.SHRDGMR_PIDM
                    and SHRTCKN.SHRTCKN_CRN = SSRATTR2.SSRATTR_CRN
                    and SHRTCKN.SHRTCKN_TERM_CODE = SSRATTR2.SSRATTR_TERM_CODE
                    and SHRTCKN.SHRTCKN_PIDM = CurrentDegree."PIDM")
              and ( ( SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                      and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                        FROM SHRTCKG
                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                      )
                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                      and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
                      and SSRATTR2.SSRATTR_ATTR_CODE ='CLIN' )
                and ( SHRTCKD_APPLIED_IND = 'Y' ) )
           ),0) < 2
           and NVL(trigger1."Times",0) < 3
           and MaxFailedTime."TotalFailedTime" =2
           or ( :Para_DD_Status.Index =1
             and MaxFailedTime."TotalFailedTime" >=3 ) ) )

union
select distinct :Para_DD_Year.YEAR||' '||:Para_DD_Review.Review_Period,
       :Para_DD_Status.status "Status",
       CurrentFailedTimeCount."ID" "StudentID",
       CurrentFailedTimeCount."FirstName" "FirstName",
       CurrentFailedTimeCount."LastName" "LastName",
       CurrentFailedTimeCount."Faculty" "Faculty",
       STVCAMP.STVCAMP_DESC "Campus",
       CurrentFailedTimeCount."DegreeCode" "DegreeCode",
       CurrentFailedTimeCount."DegreeSeqNo" "DegreeSeq",
       CurrentFailedTimeCount."DegreeStat" "DegreeStatus",
       case when (select count(SGRSATT.SGRSATT_PIDM)
                         from SGRSATT
                         where SGRSATT.SGRSATT_PIDM = CurrentFailedTimeCount."InternalId"
                          and SGRSATT.SGRSATT_ATTS_CODE in( 'EIP', 'EIPT')
                          and SGRSATT.SGRSATT_TERM_CODE_EFF = (SELECT MAX(A.SGRSATT_TERM_CODE_EFF)
                                                              FROM SGRSATT A
                                                              WHERE A.SGRSATT_PIDM = SGRSATT.SGRSATT_PIDM)) >='1'
              then 'Yes'
              else 'No'
              End "EIP",
       'Trigger 3' "Reason",
       (SELECT STVCITZ.STVCITZ_DESC
              FROM STVCITZ, SPBPERS
              WHERE SPBPERS.SPBPERS_PIDM = CurrentFailedTimeCount."InternalId"
              AND STVCITZ.STVCITZ_CODE = SPBPERS.SPBPERS_CITZ_CODE) "Citizenship",
       (SELECT STVETHN.STVETHN_DESC
              FROM STVETHN, SPBPERS
              WHERE SPBPERS.SPBPERS_PIDM = CurrentFailedTimeCount."InternalId"
              AND SPBPERS.SPBPERS_ETHN_CODE = STVETHN.STVETHN_CODE) "ATSI",
       ACU.SZKFUNC.GET_EMAIL_ADDRESS (CurrentFailedTimeCount."ID", 'STDN') "StudentEmail",
       ACU.SZKFUNC.GET_EMAIL_ADDRESS (CurrentFailedTimeCount."ID", 'PERS') "PersonalEmail",
       ACU.SZKFUNC.GET_MOBILE_NUMBER (CurrentFailedTimeCount."ID") "Mobile",
       (SELECT SPRADDR.SPRADDR_STREET_LINE1
                 FROM SPRADDR
                 WHERE CurrentFailedTimeCount."InternalId" = SPRADDR.SPRADDR_PIDM
                 AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
                 AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
                 AND SPRADDR.SPRADDR_TO_DATE is null
                 AND SPRADDR.SPRADDR_STATUS_IND is null
              ) "StreetAddress1",
       (SELECT SPRADDR.SPRADDR_STREET_LINE2
                 FROM SPRADDR
                 WHERE CurrentFailedTimeCount."InternalId" = SPRADDR.SPRADDR_PIDM
                 AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
                 AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
                 AND SPRADDR.SPRADDR_TO_DATE is null
                 AND SPRADDR.SPRADDR_STATUS_IND is null
                 ) "StreetAddress2",
       (SELECT SPRADDR.SPRADDR_CITY
                             FROM SPRADDR
                             WHERE CurrentFailedTimeCount."InternalId" = SPRADDR.SPRADDR_PIDM
                             AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
                             AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
                             AND SPRADDR.SPRADDR_TO_DATE is null
                             AND SPRADDR.SPRADDR_STATUS_IND is null
                            ) "City",
       (SELECT SPRADDR.SPRADDR_STAT_CODE
                             FROM SPRADDR
                             WHERE CurrentFailedTimeCount."InternalId" = SPRADDR.SPRADDR_PIDM
                             AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
                             AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
                             AND SPRADDR.SPRADDR_TO_DATE is null
                             AND SPRADDR.SPRADDR_STATUS_IND is null
                            ) "State",
       (SELECT SPRADDR.SPRADDR_ZIP
                 FROM SPRADDR
                WHERE CurrentFailedTimeCount."InternalId" = SPRADDR.SPRADDR_PIDM
                  AND SPRADDR.SPRADDR_ATYP_CODE = 'MA'
                  AND SPRADDR.SPRADDR_FROM_DATE <= sysdate
                  AND SPRADDR.SPRADDR_TO_DATE is null
                  AND SPRADDR.SPRADDR_STATUS_IND is null
                ) "Postcode",
       ( SELECT TO_CHAR(MAX(SHRTCKG.SHRTCKG_ACTIVITY_DATE),'DD/MM/YYYY')
           from SATURN.SHRTCKN SHRTCKN,
                SATURN.SHRTCKG SHRTCKG,
                SATURN.SHRTCKD SHRTCKD,
                SATURN.SHRDGMR SHRDGMR
         where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
             And SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+)
             and SHRTCKD.SHRTCKD_PIDM = CurrentFailedTimeCount."InternalId"
             and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = CurrentFailedTimeCount."DegreeSeqNo" )
             and SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
             and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
             and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                          FROM SHRTCKG
                                          WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                          AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                          AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO)
             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
             and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
             and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
             and ( (:Para_DD_Review.Index =1 and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82'))
                 or ( :Para_DD_Review.Index ='2' and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) )
       ) "LastFailedGradeDate",
       (SELECT LISTAGG(TO_CHAR(A.SPRCMNT_DATE,'DD/MM/YYYY')||','||A.SPRCMNT_CMTT_CODE||','||A.SPRCMNT_TEXT||';') WITHIN GROUP (ORDER BY A.SPRCMNT_ACTIVITY_DATE)
          FROM SPRCMNT A
         WHERE A.SPRCMNT_PIDM = CurrentFailedTimeCount."InternalId"
           AND A.SPRCMNT_ACTIVITY_DATE >=( SELECT MAX(SHRTCKG.SHRTCKG_ACTIVITY_DATE)
                                             from SATURN.SHRTCKN SHRTCKN,
                                                  SATURN.SHRTCKG SHRTCKG,
                                                  SATURN.SHRTCKD SHRTCKD,
                                                  SATURN.SHRDGMR SHRDGMR
                                             where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                             And SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                             and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                             and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+)
                                             and SHRTCKD.SHRTCKD_PIDM = CurrentFailedTimeCount."InternalId"
                                             and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = CurrentFailedTimeCount."DegreeSeqNo"
                                             and SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                             and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                             and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                                                         FROM SHRTCKG
                                                                         WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                                         AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                                         AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO)
                                             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                             and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
                                             and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                                             and ( (:Para_DD_Review.Index =1 and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82'))
                                             or ( :Para_DD_Review.Index ='2' and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) )
       ))) "CommentText"
  from SATURN.STVCAMP STVCAMP,
       ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                SHRDGMR.SHRDGMR_DEGC_CODE "DegreeCode",
                SPRIDEN.SPRIDEN_PIDM "InternalId",
                Count( SHRTCKN.SHRTCKN_SEQ_NO ) "InternalCrseSeqNo",
                SHRDGMR.SHRDGMR_COLL_CODE_1 "Faculty",
                SHRDGMR.SHRDGMR_CAMP_CODE "Campus",
                STVDEGS.STVDEGS_DESC "DegreeStat"
           from SATURN.SPRIDEN SPRIDEN,
                SATURN.SHRTCKN SHRTCKN,
                SATURN.SHRTCKG SHRTCKG,
                SATURN.SHRTCKD SHRTCKD,
                SATURN.SHRDGMR SHRDGMR,
                SATURN.SSRATTR SSRATTR1,
                SATURN.STVDEGS STVDEGS,
                ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                         SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                         SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                         SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                         SPRIDEN.SPRIDEN_PIDM "InternalId",
                         SHRTCKN.SHRTCKN_SUBJ_CODE "SubjAreaCode",
                         SHRTCKN.SHRTCKN_CRSE_NUMB "CrseNo"
                    from SATURN.SPRIDEN SPRIDEN,
                         SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.SHRTCKD SHRTCKD,
                         SATURN.SSRATTR SSRATTR
                   where ( SPRIDEN.SPRIDEN_PIDM = SHRTCKN.SHRTCKN_PIDM
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+)
                           and SHRTCKN.SHRTCKN_TERM_CODE = SSRATTR.SSRATTR_TERM_CODE
                           and SHRTCKN.SHRTCKN_CRN = SSRATTR.SSRATTR_CRN )
                     and ( ( SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                               FROM SHRTCKG
                               WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                               AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                               AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                             )
                             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                             and SPRIDEN.SPRIDEN_ID NOT LIKE 'P%'
                             and SSRATTR.SSRATTR_ATTR_CODE ='CLIN'
                             and SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                             and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                             and ( :Para_DD_Review.Index =1
                               and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                               or ( :Para_DD_Review.Index ='2'
                                 and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                       and ( SPRIDEN_CHANGE_IND is null )
                       and ( SHRTCKD_APPLIED_IND = 'Y' ) ) ) FailedCLIN1111
          where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM (+)
                  and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                  and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                  and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM
                  and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE
                  and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO
                  and SPRIDEN.SPRIDEN_PIDM = FailedCLIN1111."InternalId"
                  and FailedCLIN1111."InternalId" = SHRTCKD.SHRTCKD_PIDM
                  and FailedCLIN1111."InternalId" = SHRDGMR.SHRDGMR_PIDM
                  and FailedCLIN1111."DegreeSeqNo" = SHRDGMR.SHRDGMR_SEQ_NO
                  and FailedCLIN1111."DegreeSeqNo" = SHRTCKD.SHRTCKD_DGMR_SEQ_NO
                  and SHRTCKN.SHRTCKN_TERM_CODE = SSRATTR1.SSRATTR_TERM_CODE
                  and SHRTCKN.SHRTCKN_CRN = SSRATTR1.SSRATTR_CRN
                  and SHRDGMR.SHRDGMR_DEGS_CODE = STVDEGS.STVDEGS_CODE (+) )
            and ( ( SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                    and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                      FROM SHRTCKG
                      WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                      AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                      AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                    )
                    and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                    and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                    and SSRATTR1.SSRATTR_ATTR_CODE ='CLIN'
                    and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH' )
              and ( SPRIDEN_CHANGE_IND is null )
              and ( SHRTCKD_APPLIED_IND = 'Y' ) )
          group by SPRIDEN.SPRIDEN_ID,
                   SPRIDEN.SPRIDEN_FIRST_NAME,
                   SPRIDEN.SPRIDEN_LAST_NAME,
                   SHRTCKD.SHRTCKD_DGMR_SEQ_NO,
                   SHRDGMR.SHRDGMR_DEGC_CODE,
                   SPRIDEN.SPRIDEN_PIDM,
                   SHRDGMR.SHRDGMR_COLL_CODE_1,
                   SHRDGMR.SHRDGMR_CAMP_CODE,
                   STVDEGS.STVDEGS_DESC ) CurrentFailedTimeCount,
       ( select distinct SHRTCKD.SHRTCKD_PIDM "PIDM",
                Count( SHRTCKN.SHRTCKN_TERM_CODE||SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB ) "FailedCLINUnitCount"
           from SATURN.SHRTCKN SHRTCKN,
                SATURN.SHRTCKG SHRTCKG,
                SATURN.SHRTCKD SHRTCKD,
                SATURN.SHRDGMR SHRDGMR,
                SATURN.SSRATTR SSRATTR2,
                ( select distinct SHRTCKN.SHRTCKN_PIDM "PIDM",
                         SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                         SHRTCKN.SHRTCKN_SUBJ_CODE "SubjAreaCode",
                         SHRTCKN.SHRTCKN_CRSE_NUMB "CrseNo"
                    from SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.SHRTCKD SHRTCKD,
                         SATURN.SSRATTR SSRATTR,
                         SATURN.SHRDGMR SHRDGMR1
                   where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_TERM_CODE = SSRATTR.SSRATTR_TERM_CODE
                           and SHRTCKN.SHRTCKN_CRN = SSRATTR.SSRATTR_CRN
                           and SHRTCKD.SHRTCKD_PIDM = SHRDGMR1.SHRDGMR_PIDM
                           and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = SHRDGMR1.SHRDGMR_SEQ_NO )
                     and ( ( SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                               FROM SHRTCKG
                               WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                               AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                               AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                             )
                             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                             and SSRATTR.SSRATTR_ATTR_CODE ='CLIN'
                             and SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                             and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                             and SHRDGMR1.SHRDGMR_DEGS_CODE <>'AH'
                             and ( :Para_DD_Review.Index =1
                               and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                               or ( :Para_DD_Review.Index ='2'
                                 and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                       and ( SHRTCKD_APPLIED_IND = 'Y' ) ) ) FailedCLIN1
          where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                  and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                  and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                  and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM
                  and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE
                  and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO
                  and FailedCLIN1."PIDM" = SHRTCKN.SHRTCKN_PIDM
                  and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = SHRDGMR.SHRDGMR_SEQ_NO
                  and SHRTCKD.SHRTCKD_PIDM = SHRDGMR.SHRDGMR_PIDM
                  and SHRTCKN.SHRTCKN_CRN = SSRATTR2.SSRATTR_CRN
                  and SHRTCKN.SHRTCKN_TERM_CODE = SSRATTR2.SSRATTR_TERM_CODE )
            and ( ( SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                    and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                      FROM SHRTCKG
                      WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                      AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                      AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                    )
                    and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                    and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
                    and SSRATTR2.SSRATTR_ATTR_CODE ='CLIN' )
              and ( SHRTCKD_APPLIED_IND = 'Y' ) )
          group by SHRTCKD.SHRTCKD_PIDM
         having :Para_DD_Status.Index = 2  and Count( SHRTCKN.SHRTCKN_TERM_CODE||SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB ) = 1
                or ( :Para_DD_Status.Index = 1  and Count( SHRTCKN.SHRTCKN_TERM_CODE||SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB ) > 1 ) ) AllDegreeFailedCLIN,
       ( select distinct AllDegreeFailedTimeCount1."InternalId" "PIDM",
                Max( AllDegreeFailedTimeCount1."FailedTimes" + nvl(EqiFailedTimes1."FailedEqiUnitTerrm",0) ) "TotalFailedTime"
           from ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                         SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                         SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                         SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB "Unit",
                         Count( SHRTCKN.SHRTCKN_TERM_CODE||SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB ) "FailedTimes",
                         SPRIDEN.SPRIDEN_PIDM "InternalId"
                    from SATURN.SPRIDEN SPRIDEN,
                         SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.SHRDGMR SHRDGMR1,
                         ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                                  SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                                  SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                                  SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                                  SPRIDEN.SPRIDEN_PIDM "InternalId",
                                  SHRTCKN.SHRTCKN_SUBJ_CODE "SubjAreaCode",
                                  SHRTCKN.SHRTCKN_CRSE_NUMB "CrseNo"
                             from SATURN.SPRIDEN SPRIDEN,
                                  SATURN.SHRTCKN SHRTCKN,
                                  SATURN.SHRTCKG SHRTCKG,
                                  SATURN.SHRTCKD SHRTCKD
                            where ( SPRIDEN.SPRIDEN_PIDM = SHRTCKN.SHRTCKN_PIDM
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+) )
                              and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                      and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                      and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                        FROM SHRTCKG
                                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                      )
                                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                      and SPRIDEN.SPRIDEN_ID NOT LIKE 'P%'
                                      and (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                       FROM SSRATTR A
                                       WHERE A.SSRATTR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                                       AND A.SSRATTR_CRN = SHRTCKN.SHRTCKN_CRN
                                       AND A.SSRATTR_ATTR_CODE = 'CLIN') =0
                                      and ( :Para_DD_Review.Index =1
                                        and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                        or ( :Para_DD_Review.Index ='2'
                                          and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                and ( SPRIDEN_CHANGE_IND is null )
                                and ( SHRTCKD_APPLIED_IND = 'Y' ) ) ) FailedNONCLIN2
                   where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SPRIDEN.SPRIDEN_PIDM = FailedNONCLIN2."InternalId"
                           and FailedNONCLIN2."InternalId" = SHRTCKN.SHRTCKN_PIDM
                           and FailedNONCLIN2."SubjAreaCode" = SHRTCKN.SHRTCKN_SUBJ_CODE
                           and FailedNONCLIN2."CrseNo" = SHRTCKN.SHRTCKN_CRSE_NUMB
                           and FailedNONCLIN2."InternalId" = SHRDGMR1.SHRDGMR_PIDM
                           and FailedNONCLIN2."DegreeSeqNo" = SHRDGMR1.SHRDGMR_SEQ_NO )
                     and ( ( SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                               FROM SHRTCKG
                               WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                               AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                               AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                             )
                             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                             and SHRDGMR1.SHRDGMR_DEGS_CODE <>'AH'
                             and ( :Para_DD_Review.Index =1
                               and SHRTCKN.SHRTCKN_TERM_CODE <=:Para_DD_Year.YEAR*100+47
                               and SHRTCKN.SHRTCKN_TERM_CODE <>:Para_DD_Year.YEAR*100+45
                               or ( :Para_DD_Review.Index =2
                                 and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97 ) ) )
                       and ( SPRIDEN_CHANGE_IND is null ) )
                   group by SPRIDEN.SPRIDEN_ID,
                            SPRIDEN.SPRIDEN_FIRST_NAME,
                            SPRIDEN.SPRIDEN_LAST_NAME,
                            SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB,
                            SPRIDEN.SPRIDEN_PIDM ) AllDegreeFailedTimeCount1,
                ( select distinct SPRIDEN.SPRIDEN_PIDM "InternalId",
                         Count( SHRTCKN.SHRTCKN_TERM_CODE||Query."EqivSub"||Query."EqivCrsNo" ) "FailedEqiUnitTerrm",
                         Query."SubjectCode"||Query."CrseNo" "FailedUnit"
                    from SATURN.SPRIDEN SPRIDEN,
                         SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.SHRTCKD SHRTCKD,
                         SATURN.SHRDGMR SHRDGMR,
                         ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                                  SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                                  SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                                  SHRTCKN.SHRTCKN_TERM_CODE "Term",
                                  SHRTCKN.SHRTCKN_CRN "CRN",
                                  SHRTCKG.SHRTCKG_GRDE_CODE_FINAL "Grade",
                                  SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                                  (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                   FROM SSRATTR A
                                   WHERE A.SSRATTR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                                   AND A.SSRATTR_CRN = SHRTCKN.SHRTCKN_CRN
                                   AND A.SSRATTR_ATTR_CODE = 'CLIN') "CLIN",
                                  SPRIDEN.SPRIDEN_PIDM "InternalId",
                                  SHRTCKN.SHRTCKN_SUBJ_CODE "SubjAreaCode",
                                  SHRTCKN.SHRTCKN_CRSE_NUMB "CrseNo"
                             from SATURN.SPRIDEN SPRIDEN,
                                  SATURN.SHRTCKN SHRTCKN,
                                  SATURN.SHRTCKG SHRTCKG,
                                  SATURN.SHRTCKD SHRTCKD
                            where ( SPRIDEN.SPRIDEN_PIDM = SHRTCKN.SHRTCKN_PIDM
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+) )
                              and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                      and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                      and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                        FROM SHRTCKG
                                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                      )
                                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                      and SPRIDEN.SPRIDEN_ID NOT LIKE 'P%'
                                      and (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                       FROM SSRATTR A
                                       WHERE A.SSRATTR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                                       AND A.SSRATTR_CRN = SHRTCKN.SHRTCKN_CRN
                                       AND A.SSRATTR_ATTR_CODE = 'CLIN') =0
                                      and ( :Para_DD_Review.Index =1
                                        and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                        or ( :Para_DD_Review.Index ='2'
                                          and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                and ( SPRIDEN_CHANGE_IND is null )
                                and ( SHRTCKD_APPLIED_IND = 'Y' ) )
                            order by SPRIDEN.SPRIDEN_ID,
                                     SHRTCKN.SHRTCKN_TERM_CODE ) FailedNONCLIN3,
                         ( select distinct SSBSECT2.SSBSECT_TERM_CODE "Term",
                                  SSBSECT2.SSBSECT_CRN "CRN",
                                  SSBSECT2.SSBSECT_SUBJ_CODE "SubjectCode",
                                  SSBSECT2.SSBSECT_CRSE_NUMB "CrseNo",
                                  SCREQIV1.SCREQIV_SUBJ_CODE_EQIV "EqivSub",
                                  SCREQIV1.SCREQIV_CRSE_NUMB_EQIV "EqivCrsNo"
                             from SATURN.SSBSECT SSBSECT2,
                                  SATURN.SCREQIV SCREQIV1
                            where ( SSBSECT2.SSBSECT_SUBJ_CODE = SCREQIV1.SCREQIV_SUBJ_CODE
                                    and SSBSECT2.SSBSECT_CRSE_NUMB = SCREQIV1.SCREQIV_CRSE_NUMB )
                              and ( SSBSECT2.SSBSECT_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                    and SSBSECT2.SSBSECT_TERM_CODE < :Para_DD_Year.YEAR *100 + 97
                                    and SCREQIV1.SCREQIV_END_TERM >=SSBSECT2.SSBSECT_TERM_CODE
                                    and SCREQIV1.SCREQIV_EFF_TERM <=SSBSECT2.SSBSECT_TERM_CODE
                                    and (SELECT COUNT(A.SSRATTR_ATTR_CODE)
                                     FROM SSRATTR A
                                     WHERE A.SSRATTR_TERM_CODE = SSBSECT2.SSBSECT_TERM_CODE
                                     AND A.SSRATTR_CRN = SSBSECT2.SSBSECT_CRN
                                     AND A.SSRATTR_ATTR_CODE = 'CLIN') =0
                                    and ( :Para_DD_Review.Index =1
                                      and SUBSTR(SSBSECT2.SSBSECT_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                      or ( :Para_DD_Review.Index =2
                                        and SUBSTR(SSBSECT2.SSBSECT_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                            order by 1,
                                     3 ) Query
                   where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO
                           and SPRIDEN.SPRIDEN_PIDM = FailedNONCLIN3."InternalId"
                           and Query."EqivSub" = SHRTCKN.SHRTCKN_SUBJ_CODE
                           and Query."EqivCrsNo" = SHRTCKN.SHRTCKN_CRSE_NUMB
                           and FailedNONCLIN3."InternalId" = SHRDGMR.SHRDGMR_PIDM
                           and FailedNONCLIN3."DegreeSeqNo" = SHRDGMR.SHRDGMR_SEQ_NO
                           and FailedNONCLIN3."Term" = Query."Term"
                           and FailedNONCLIN3."CRN" = Query."CRN"
                           and FailedNONCLIN3."InternalId" = SHRTCKD.SHRTCKD_PIDM )
                     and ( ( SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                             and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                               FROM SHRTCKG
                               WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                               AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                               AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                             )
                             and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                             and SHRTCKN.SHRTCKN_TERM_CODE <=Query."Term"
                             and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH' )
                       and ( SPRIDEN_CHANGE_IND is null )
                       and ( SHRTCKD_APPLIED_IND = 'Y' ) )
                   group by SPRIDEN.SPRIDEN_PIDM,
                            Query."SubjectCode"||Query."CrseNo" ) EqiFailedTimes1
          where ( AllDegreeFailedTimeCount1."InternalId" = EqiFailedTimes1."InternalId" (+)
                  and AllDegreeFailedTimeCount1."Unit" = EqiFailedTimes1."FailedUnit" (+) )
          group by AllDegreeFailedTimeCount1."InternalId" ) trigger2,
       ( select distinct datascope11."InternalId" "PIDM",
                Count( FailedUnit1."InternalId" ) "Times"
           from ( select distinct SPRIDEN.SPRIDEN_ID "ID",
                         TotalUnit21."DegreeSeqNo" "DegreeSeq",
                         SPRIDEN.SPRIDEN_FIRST_NAME "FirstName",
                         SPRIDEN.SPRIDEN_LAST_NAME "LastName",
                         ROUND(FailedUnitCount1."CreditHours"/(DECODE((NVL(TotalUnit21."TotalCP",0) + NVL(BlankUnitCount."CreditHours",0)),0,1,(NVL(TotalUnit21."TotalCP",0) + NVL(BlankUnitCount."CreditHours",0)))),2)*100 "PctFailedCP",
                         ROUND(FailedUnitCount1."Unit"/(DECODE((NVL(TotalUnit21."ToatlUnitCount",0) + NVL(BlankUnitCount."Count",0)),0,1,(NVL(TotalUnit21."ToatlUnitCount",0) + NVL(BlankUnitCount."Count",0)))),2)*100 "PctFailedUnit",
                         (select  listagg(SGRSATT.SGRSATT_TERM_CODE_EFF|| ', ') within group (order by SGRSATT.SGRSATT_PIDM)
                                 from sgrsatt
                                 where SGRSATT.SGRSATT_PIDM = SPRIDEN.SPRIDEN_PIDM
                                  and SGRSATT.SGRSATT_ATTS_CODE = 'SHCA'
                                  and SGRSATT.SGRSATT_TERM_CODE_EFF > (SELECT MIN(A.SHRTCKD_TERM_CODE)
                                                                       FROM SHRTCKD A
                                                                       WHERE A.SHRTCKD_PIDM = FailedUnitCount1."InternalId"
                                                                       AND A.SHRTCKD_DGMR_SEQ_NO = TotalUnit21."DegreeSeqNo"
                                                                       AND A.SHRTCKD_APPLIED_IND ='Y')
                                  group by SGRSATT.SGRSATT_PIDM) "SHCA",
                         SPRIDEN.SPRIDEN_PIDM "InternalId"
                    from SATURN.SPRIDEN SPRIDEN,
                         ( select distinct SHRTCKN.SHRTCKN_PIDM "PIDM",
                                  Count( SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB ) "ToatlUnitCount",
                                  Sum( SHRTCKG.SHRTCKG_CREDIT_HOURS ) "TotalCP",
                                  SHRDGMR.SHRDGMR_SEQ_NO "DegreeSeqNo"
                             from SATURN.SHRTCKN SHRTCKN,
                                  SATURN.SHRTCKG SHRTCKG,
                                  SATURN.SHRTCKD SHRTCKD,
                                  SATURN.SHRDGMR SHRDGMR
                            where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+)
                                    and SHRTCKD.SHRTCKD_PIDM = SHRDGMR.SHRDGMR_PIDM
                                    and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = SHRDGMR.SHRDGMR_SEQ_NO )
                              and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                      and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                      and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                        FROM SHRTCKG
                                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                      )
                                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('HD', 'DI', 'CR', 'PA', 'PX', 'NN', 'NH', 'NU', 'WN','PS','IP',
                                      'NF',
                                      'RP',
                                      'DE',
                                      'RW',
                                      'CU',
                                      'CE',
                                      'NL')
                                      and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
                                      and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                                      and ( :Para_DD_Review.Index =1
                                        and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                        or ( :Para_DD_Review.Index ='2'
                                          and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                and ( SHRTCKD_APPLIED_IND = 'Y' ) )
                            group by SHRTCKN.SHRTCKN_PIDM,
                                     SHRDGMR.SHRDGMR_SEQ_NO
                            order by SHRTCKN.SHRTCKN_TERM_CODE ) TotalUnit21,
                         ( select distinct SHRTCKN.SHRTCKN_PIDM "InternalId",
                                  Count( SHRTCKN.SHRTCKN_SUBJ_CODE||SHRTCKN.SHRTCKN_CRSE_NUMB ) "Unit",
                                  Sum( SHRTCKG.SHRTCKG_CREDIT_HOURS ) "CreditHours",
                                  SHRDGMR.SHRDGMR_SEQ_NO "DegreeSeqNo"
                             from SATURN.SHRTCKN SHRTCKN,
                                  SATURN.SHRTCKG SHRTCKG,
                                  SATURN.SHRTCKD SHRTCKD,
                                  SATURN.SHRDGMR SHRDGMR
                            where ( SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                    and SHRTCKN.SHRTCKN_PIDM = SHRTCKD.SHRTCKD_PIDM (+)
                                    and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKD.SHRTCKD_TERM_CODE (+)
                                    and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKD.SHRTCKD_TCKN_SEQ_NO (+)
                                    and SHRTCKD.SHRTCKD_PIDM = SHRDGMR.SHRDGMR_PIDM
                                    and SHRTCKD.SHRTCKD_DGMR_SEQ_NO = SHRDGMR.SHRDGMR_SEQ_NO )
                              and ( ( SHRTCKN.SHRTCKN_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                      and SHRTCKN.SHRTCKN_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                      and SHRTCKG.SHRTCKG_SEQ_NO =(SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                        FROM SHRTCKG
                                        WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                        AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                        AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                      )
                                      and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL')
                                      and SHRDGMR.SHRDGMR_DEGS_CODE <>'AH'
                                      and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                                      and ( :Para_DD_Review.Index =1
                                        and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                        or ( :Para_DD_Review.Index ='2'
                                          and SUBSTR(SHRTCKN.SHRTCKN_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                                and ( SHRTCKD_APPLIED_IND = 'Y' ) )
                            group by SHRTCKN.SHRTCKN_PIDM,
                                     SHRDGMR.SHRDGMR_SEQ_NO
                            order by SHRTCKN.SHRTCKN_TERM_CODE ) FailedUnitCount1,
                         ( select distinct SFRSTCR.SFRSTCR_PIDM "PIDM",
                                  Count( SFRSTCR.SFRSTCR_PIDM ) "Count",
                                  Sum( SFRSTCR.SFRSTCR_CREDIT_HR ) "CreditHours"
                             from SATURN.SFRSTCR SFRSTCR,
                                  SATURN.SHRTCKN SHRTCKN
                            where ( SFRSTCR.SFRSTCR_PIDM = SHRTCKN.SHRTCKN_PIDM (+)
                                    and SFRSTCR.SFRSTCR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE (+)
                                    and SFRSTCR.SFRSTCR_CRN = SHRTCKN.SHRTCKN_CRN (+) )
                              and ( SFRSTCR.SFRSTCR_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                                    and SFRSTCR.SFRSTCR_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                                    and SFRSTCR.SFRSTCR_GRDE_CODE is null
                                    and (SELECT SHRTCKG.SHRTCKG_GRDE_CODE_FINAL
                                                            FROM SHRTCKG
                                                           WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                             AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                             AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                                             AND SHRTCKG.SHRTCKG_SEQ_NO = (SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                                                                             FROM SHRTCKG
                                                                                            WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                                                             AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                                                             AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                                                                    )) is null
                                    and SFRSTCR.SFRSTCR_RSTS_CODE IN ('RE','RW','DF','DN','DP')
                                    and ( :Para_DD_Review.Index =1
                                      and SUBSTR(SFRSTCR.SFRSTCR_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                                      or ( :Para_DD_Review.Index ='2'
                                        and SUBSTR(SFRSTCR.SFRSTCR_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                            group by SFRSTCR.SFRSTCR_PIDM
                            order by SFRSTCR.SFRSTCR_PIDM ) BlankUnitCount
                   where ( SPRIDEN.SPRIDEN_PIDM = TotalUnit21."PIDM"
                           and TotalUnit21."PIDM" = FailedUnitCount1."InternalId" (+)
                           and TotalUnit21."DegreeSeqNo" = FailedUnitCount1."DegreeSeqNo" (+)
                           and SPRIDEN.SPRIDEN_PIDM = BlankUnitCount."PIDM" (+) )
                     and ( ( SPRIDEN.SPRIDEN_ID NOT LIKE 'P%'
                             and ( ROUND(FailedUnitCount1."CreditHours"/(DECODE((NVL(TotalUnit21."TotalCP",0) + NVL(BlankUnitCount."CreditHours",0)),0,1,(NVL(TotalUnit21."TotalCP",0) + NVL(BlankUnitCount."CreditHours",0)))),2)*100 >=50
                               or ROUND(FailedUnitCount1."Unit"/(DECODE((NVL(TotalUnit21."ToatlUnitCount",0) + NVL(BlankUnitCount."Count",0)),0,1,(NVL(TotalUnit21."ToatlUnitCount",0) + NVL(BlankUnitCount."Count",0)))),2)*100 >=50 ) )
                       and ( SPRIDEN_CHANGE_IND is null ) ) ) datascope11,
                ( select distinct SHRTCKD.SHRTCKD_PIDM "InternalId",
                         SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                         CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) ='97'
                              THEN TO_CHAR(STVTERM.STVTERM_ACYR_CODE + 1)
                              ELSE STVTERM.STVTERM_ACYR_CODE
                         END "ReviewYear",
                         CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                         THEN '1'
                         ELSE CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2)  IN ('45','55','60','65','70','56','76','86','87')
                              THEN '2'
                              END
                         END "ReviewPeriod",
                         Sum( SHRTCKG.SHRTCKG_CREDIT_HOURS ) "TotalGreditHours",
                         Count( SHRTCKN.SHRTCKN_CRN ) "TotalUnitCount"
                    from SATURN.SHRTCKD SHRTCKD,
                         SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.STVTERM STVTERM
                   where ( SHRTCKD.SHRTCKD_PIDM = SHRTCKN.SHRTCKN_PIDM
                           and SHRTCKD.SHRTCKD_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                           and SHRTCKD.SHRTCKD_TCKN_SEQ_NO = SHRTCKN.SHRTCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SHRTCKD.SHRTCKD_TERM_CODE = STVTERM.STVTERM_CODE )
                     and ( SHRTCKG.SHRTCKG_SEQ_NO = (SELECT MAX(A.SHRTCKG_SEQ_NO)
                             FROM SHRTCKG A
                             WHERE A.SHRTCKG_PIDM = SHRTCKG.SHRTCKG_PIDM
                             AND A.SHRTCKG_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                             AND A.SHRTCKG_TCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO)
                           and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                           and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('NN', 'WN','NH', 'NU','NL') )
                   group by SHRTCKD.SHRTCKD_PIDM,
                            SHRTCKD.SHRTCKD_DGMR_SEQ_NO,
                            CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) ='97'
                       THEN TO_CHAR(STVTERM.STVTERM_ACYR_CODE + 1)
                       ELSE STVTERM.STVTERM_ACYR_CODE
                  END,
                            CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                  THEN '1'
                  ELSE CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2)  IN ('45','55','60','65','70','56','76','86','87')
                       THEN '2'
                       END
                  END ) FailedUnit1,
                ( select distinct SHRTCKD.SHRTCKD_PIDM "InternalId",
                         SHRTCKD.SHRTCKD_DGMR_SEQ_NO "DegreeSeqNo",
                         CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) ='97'
                              THEN TO_CHAR(STVTERM.STVTERM_ACYR_CODE + 1)
                              ELSE STVTERM.STVTERM_ACYR_CODE
                         END "ReviewYear",
                         CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                         THEN '1'
                         ELSE CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2)  IN ('45','55','60','65','70','56','76','86','87')
                              THEN '2'
                              END
                         END "ReviewPeriod",
                         Sum( SHRTCKG.SHRTCKG_CREDIT_HOURS ) "TotalGreditHours",
                         Count( SHRTCKN.SHRTCKN_CRN ) "TotalUnitCount"
                    from SATURN.SHRTCKD SHRTCKD,
                         SATURN.SHRTCKN SHRTCKN,
                         SATURN.SHRTCKG SHRTCKG,
                         SATURN.STVTERM STVTERM
                   where ( SHRTCKD.SHRTCKD_PIDM = SHRTCKN.SHRTCKN_PIDM
                           and SHRTCKD.SHRTCKD_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE
                           and SHRTCKD.SHRTCKD_TCKN_SEQ_NO = SHRTCKN.SHRTCKN_SEQ_NO
                           and SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                           and SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                           and SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                           and SHRTCKD.SHRTCKD_TERM_CODE = STVTERM.STVTERM_CODE )
                     and ( SHRTCKG.SHRTCKG_SEQ_NO = (SELECT MAX(A.SHRTCKG_SEQ_NO)
                             FROM SHRTCKG A
                             WHERE A.SHRTCKG_PIDM = SHRTCKG.SHRTCKG_PIDM
                             AND A.SHRTCKG_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                             AND A.SHRTCKG_TCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO)
                           and SHRTCKD.SHRTCKD_APPLIED_IND ='Y'
                           and SHRTCKG.SHRTCKG_GRDE_CODE_FINAL IN ('HD', 'DI', 'CR', 'PA', 'PX', 'NN', 'NH', 'NU', 'WN','PS','IP',
                           'NF',
                           'RP',
                           'DE',
                           'RW',
                           'CU',
                           'CE','NL') )
                   group by SHRTCKD.SHRTCKD_PIDM,
                            SHRTCKD.SHRTCKD_DGMR_SEQ_NO,
                            CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) ='97'
                       THEN TO_CHAR(STVTERM.STVTERM_ACYR_CODE + 1)
                       ELSE STVTERM.STVTERM_ACYR_CODE
                  END,
                            CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                  THEN '1'
                  ELSE CASE WHEN SUBSTR(STVTERM.STVTERM_CODE,5,2)  IN ('45','55','60','65','70','56','76','86','87')
                       THEN '2'
                       END
                  END ) TotalUnit11,
                ( select distinct SFRSTCR.SFRSTCR_PIDM "PIDM",
                         Count( SFRSTCR.SFRSTCR_PIDM ) "Count",
                         Sum( SFRSTCR.SFRSTCR_CREDIT_HR ) "CreditHours"
                    from SATURN.SFRSTCR SFRSTCR,
                         SATURN.SHRTCKN SHRTCKN
                   where ( SFRSTCR.SFRSTCR_PIDM = SHRTCKN.SHRTCKN_PIDM (+)
                           and SFRSTCR.SFRSTCR_TERM_CODE = SHRTCKN.SHRTCKN_TERM_CODE (+)
                           and SFRSTCR.SFRSTCR_CRN = SHRTCKN.SHRTCKN_CRN (+) )
                     and ( SFRSTCR.SFRSTCR_TERM_CODE >= (:Para_DD_Year.YEAR - 1)*100 + 97
                           and SFRSTCR.SFRSTCR_TERM_CODE <:Para_DD_Year.YEAR *100 + 97
                           and SFRSTCR.SFRSTCR_GRDE_CODE is null
                           and (SELECT SHRTCKG.SHRTCKG_GRDE_CODE_FINAL
                                                   FROM SHRTCKG
                                                  WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                    AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                    AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                                    AND SHRTCKG.SHRTCKG_SEQ_NO = (SELECT MAX(SHRTCKG.SHRTCKG_SEQ_NO)
                                                                                    FROM SHRTCKG
                                                                                   WHERE SHRTCKN.SHRTCKN_PIDM = SHRTCKG.SHRTCKG_PIDM
                                                                                    AND SHRTCKN.SHRTCKN_TERM_CODE = SHRTCKG.SHRTCKG_TERM_CODE
                                                                                    AND SHRTCKN.SHRTCKN_SEQ_NO = SHRTCKG.SHRTCKG_TCKN_SEQ_NO
                                                                           )) is null
                           and SFRSTCR.SFRSTCR_RSTS_CODE IN ('RE','RW','DF','DN','DP')
                           and ( :Para_DD_Review.Index =1
                             and SUBSTR(SFRSTCR.SFRSTCR_TERM_CODE,5,2) IN ('97','05','07','12','15','30','47','16','36','81','82')
                             or ( :Para_DD_Review.Index ='2'
                               and SUBSTR(SFRSTCR.SFRSTCR_TERM_CODE,5,2) IN ('45','55','60','65','70','56','76','86','87') ) ) )
                   group by SFRSTCR.SFRSTCR_PIDM
                   order by SFRSTCR.SFRSTCR_PIDM ) BlankUnit2
          where ( TotalUnit11."InternalId" = FailedUnit1."InternalId" (+)
                  and TotalUnit11."DegreeSeqNo" = FailedUnit1."DegreeSeqNo" (+)
                  and TotalUnit11."ReviewYear" = FailedUnit1."ReviewYear" (+)
                  and TotalUnit11."ReviewPeriod" = FailedUnit1."ReviewPeriod" (+)
                  and datascope11."InternalId" = TotalUnit11."InternalId"
                  and datascope11."DegreeSeq" = TotalUnit11."DegreeSeqNo"
                  and datascope11."InternalId" = BlankUnit2."PIDM" (+) )
            and ( datascope11."ID" not like 'P%'
                  and ( ROUND(FailedUnit1."TotalGreditHours"/(DECODE((NVL(TotalUnit11."TotalGreditHours",0) + NVL(BlankUnit2."CreditHours",0)),0,1,(NVL(TotalUnit11."TotalGreditHours",0) + NVL(BlankUnit2."CreditHours",0)))),2)*100 >= 50
                    or ROUND(FailedUnit1."TotalUnitCount"/(DECODE((NVL(TotalUnit11."TotalUnitCount",0) + NVL(BlankUnit2."Count",0)),0,1,(NVL(TotalUnit11."TotalUnitCount",0) + NVL(BlankUnit2."Count",0)))),2)*100 >= 50 ) )
          group by datascope11."InternalId" ) trigger1
 where ( CurrentFailedTimeCount."Campus" = STVCAMP.STVCAMP_CODE (+)
         and AllDegreeFailedCLIN."PIDM" = CurrentFailedTimeCount."InternalId"
         and CurrentFailedTimeCount."InternalId" = trigger2."PIDM" (+)
         and CurrentFailedTimeCount."InternalId" = trigger1."PIDM" (+) )
   and ( CurrentFailedTimeCount."Faculty" =:ListBox_faculty.FacultyCode
         and ( :para_CB_allfdegr ='N'
           and CurrentFailedTimeCount."DegreeCode" =:ListBox_degree.DegreeCode
           or ( :para_CB_allfdegr ='Y' ) )
         and ( :para_CB_allcampus2 ='N'
           and CurrentFailedTimeCount."Campus" =:ListBox_Campus.DICCode
           or ( :para_CB_allcampus2 ='Y' ) )
         and ( :Para_DD_Status.Index =1
           or ( :Para_DD_Status.Index =2
             and NVL(trigger1."Times",0) <= 2
             and NVL(trigger2."TotalFailedTime",0) <=2 ) ) )


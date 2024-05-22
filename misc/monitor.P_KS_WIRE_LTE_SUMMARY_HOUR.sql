DROP PROCEDURE IF EXISTS monitor.P_KS_WIRE_LTE_SUMMARY_HOUR;

CREATE PROCEDURE monitor.`P_KS_WIRE_LTE_SUMMARY_HOUR` ()
be:
BEGIN
   DECLARE data_time1, data_time2, data_time1_1, data_time2_2, data_time   datetime;
   DECLARE cnt1, cnt2                                                      int;

SELECT 
    DATE_ADD(MAX(start_time),
        INTERVAL 15 MINUTE)
INTO data_time1 FROM
    p_huawei_eutrancelltdd_15
WHERE
    start_time <= NOW();

SELECT 
    DATE_ADD(MAX(start_time),
        INTERVAL 15 MINUTE)
INTO data_time2 FROM
    p_nuoxi_eutrancelltdd_15
WHERE
    start_time <= NOW();

   IF data_time1 IS NULL AND data_time2 IS NULL
   THEN
      LEAVE be;
   ELSE
      SET data_time1_1 = coalesce(data_time1, data_time2);
      SET data_time2_2 = coalesce(data_time2, data_time1);
      SET data_time =
             if(data_time1_1 <= data_time2_2, data_time1_1, data_time2_2);
   END IF;

SELECT 
    COUNT(*)
INTO cnt1 FROM
    wire_lte_unity_summary_60
WHERE
    start_time = DATE_ADD(CONCAT(DATE(data_time),
                ' ',
                HOUR(data_time),
                ':00:00'),
        INTERVAL - 1 HOUR);

   IF cnt1 > 0
   THEN
      DELETE FROM wire_lte_unity_summary_60
       WHERE start_time = date_add(concat(date(data_time),
                                          ' ',
                                          hour(data_time),
                                          ':00:00'),
                                   INTERVAL -1 HOUR);

      COMMIT;
   END IF;

SELECT 
    COUNT(*)
INTO cnt2 FROM
    wire_lte_all_summary
WHERE
    start_time = DATE_ADD(CONCAT(DATE(data_time),
                ' ',
                HOUR(data_time),
                ':00:00'),
        INTERVAL - 1 HOUR)
        AND sum_type LIKE '%hour%';

   IF cnt2 > 0
   THEN
      DELETE FROM wire_lte_all_summary
       WHERE     start_time = date_add(concat(date(data_time),
                                              ' ',
                                              hour(data_time),
                                              ':00:00'),
                                       INTERVAL -1 HOUR)
             AND sum_type LIKE '%hour%';

      COMMIT;
   END IF;

   INSERT INTO wire_lte_unity_summary_60
      SELECT str_to_date(concat(date(phe.start_time),
                                ' ',
                                hour(phe.start_time),
                                ':00:00'),
                         '%Y-%m-%d %H:%i:%s')
                start_time,
             drrc.label_cn,
             phe.label_cn,
             phe.int_id,
             concat(drrc.enb_id, '-', drrc.cell_id) ecgi,
             '��Ϊ' vendor,
             drrc.maintain_dept shudi,
             round(sum(ifnull(phe.PDCP_UpOctUl, 0)), 2) pdcp_up,
             round(sum(ifnull(PDCP_UpOctDl, 0)), 2) pdcp_dl,
             round(
                sum(ifnull(phe.PDCP_UpOctUl, 0) + ifnull(PDCP_UpOctDl, 0)),
                2)
                pdcp_sum,
             round(sum(ifnull(phe.RRC_AttConnEstab, 0)), 2) rrc_attconnestab,
             round(sum(ifnull(phe.RRC_SuccConnEstab, 0)), 2)
                rrc_succconnestab,
             round(  sfb_divfloat(sum(ifnull(phe.RRC_SuccConnEstab, 0)),
                                  sum(ifnull(phe.RRC_AttConnEstab, 0)),
                                  1,
                                  1)
                   * 100,
                   2)
                rrc_succ_rate,
             round(sum(ifnull(phe.ERAB_NbrAttEstab, 0)), 2) erab_nbrattestab,
             round(sum(ifnull(phe.ERAB_NbrSuccEstab, 0)), 2)
                erab_nbrsuccestab,
             round(  sfb_divfloat(sum(ifnull(phe.ERAB_NbrSuccEstab, 0)),
                                  sum(ifnull(phe.ERAB_NbrAttEstab, 0)),
                                  1,
                                  1)
                   * 100,
                   2)
                erab_succ_rate,
             round(
                  sfb_divfloat(
                       sum(ifnull(phe.ERAB_NbrSuccEstab, 0))
                     * sum(ifnull(phe.RRC_SuccConnEstab, 0)),
                       sum(ifnull(phe.ERAB_NbrAttEstab, 0))
                     * sum(ifnull(phe.RRC_AttConnEstab, 0)),
                     1,
                     1)
                * 100,
                2)
                wireless_conn_rate,
             round(sum(ifnull(phe.CONTEXT_AttRelEnb, 0)), 2)
                context_attrelenb,
             round(sum(ifnull(phe.CONTEXT_AttRelEnb_Normal, 0)), 2)
                context_att_normal,
             round(sum(ifnull(phe.CONTEXT_SuccInitalSetup, 0)), 2)
                context_succ_init,
             round(
                  sfb_divfloat(
                     sum(
                          ifnull(phe.CONTEXT_AttRelEnb, 0)
                        - ifnull(phe.CONTEXT_AttRelEnb_Normal, 0)),
                     sum(
                          ifnull(phe.CONTEXT_SuccInitalSetup, 0)
                        + ifnull(phe.CONTEXT_NbrLeft, 0)),
                     0,
                     0)
                * 100,
                2)
                wireless_dropping_rate,
             round(sum(ifnull(phe.CONTEXT_NbrLeft, 0)), 2) CONTEXT_NbrLeft,
             round(
                  sfb_divfloat(
                     sum(
                          ifnull(phe.HO_SuccOutInterEnbS1, 0)
                        + ifnull(phe.HO_SuccOutInterEnbX2, 0)
                        + ifnull(phe.HO_SuccOutIntraEnb, 0)),
                     sum(
                          ifnull(phe.HO_AttOutInterEnbS1, 0)
                        + ifnull(phe.HO_AttOutInterEnbX2, 0)
                        + ifnull(phe.HO_AttOutIntraEnb, 0)),
                     1,
                     1)
                * 100,
                2)
                sw_succ_rate,
             avg(ifnull(phe.RRU_PuschPrbTotMeanUl, 0)) RRU_PuschPrbTotMeanUl,
             avg(ifnull(phe.RRU_PdschPrbTotMeanDl, 0)) RRU_PdschPrbTotMeanDl,
             avg(ifnull(phe.RRU_PuschPrbMeanTot, 0)) RRU_PuschPrbMeanTot,
             avg(ifnull(phe.RRU_PdschPrbMeanTot, 0)) RRU_PdschPrbMeanTot,
             avg(ifnull(phe.RRU_DtchPrbAssnMeanUl, 0)) RRU_DtchPrbAssnMeanUl,
             avg(ifnull(phe.RRU_DtchPrbAssnMeanDl, 0)) RRU_DtchPrbAssnMeanDl,
             round(  sfb_divfloat(sum(ifnull(phe.RRU_PuschPrbTotMeanUl, 0)),
                                  sum(ifnull(phe.RRU_PuschPrbMeanTot, 0)),
                                  0,
                                  0)
                   * 100,
                   2)
                u_prb_avg_use_r,
             round(  sfb_divfloat(sum(ifnull(phe.RRU_PdschPrbTotMeanDl, 0)),
                                  sum(ifnull(phe.RRU_PdschPrbMeanTot, 0)),
                                  0,
                                  0)
                   * 100,
                   2)
                d_prb_avg_use_r,
             avg(ifnull(phe.RRU_PdcchCceUtilRatio, 0)) RRU_PdcchCceUtilRatio,
             avg(ifnull(phe.RRC_ConnMean, 0)) RRC_ConnMean,
             max(ifnull(phe.RRC_ConnMax, 0)) RRC_ConnMax,
             avg(ifnull(phe.RRC_EffectiveConnMean, 0)) RRC_EffectiveConnMean,
             max(ifnull(phe.RRC_EffectiveConnMax, 0)) RRC_EffectiveConnMax,
             sum(ifnull(phe.HO_SuccOutInterEnbS1, 0)) HO_SuccOutInterEnbS1,
             sum(ifnull(phe.HO_SuccOutInterEnbX2, 0)) HO_SuccOutInterEnbX2,
             sum(ifnull(phe.HO_SuccOutIntraEnb, 0)) HO_SuccOutIntraEnb,
             sum(ifnull(phe.HO_AttOutInterEnbS1, 0)) HO_AttOutInterEnbS1,
             sum(ifnull(phe.HO_AttOutInterEnbX2, 0)) HO_AttOutInterEnbX2,
             sum(ifnull(phe.HO_AttOutIntraEnb, 0)) HO_AttOutIntraEnb,
             sum(ifnull(phe.PDCP_UpOctUl_1, 0)) PDCP_UpOctUl_1,
             sum(ifnull(phe.PDCP_UpOctDl_1, 0)) PDCP_UpOctDl_1,
             sum(ifnull(phe.ERAB_NbrMeanEstab_1, 0)) ERAB_NbrMeanEstab_1,
             sum(ifnull(phe.PDCP_UpOctUl_2, 0)) PDCP_UpOctUl_2,
             sum(ifnull(phe.PDCP_UpOctDl_2, 0)) PDCP_UpOctDl_2,
             sum(ifnull(phe.ERAB_NbrMeanEstab_2, 0)) ERAB_NbrMeanEstab_2,
             sum(ifnull(phe.ERAB_NbrSuccEstab_1, 0)) ERAB_NbrSuccEstab_1,
             sum(ifnull(phe.ERAB_NbrAttEstab_1, 0)) ERAB_NbrAttEstab_1,
             sum(ifnull(phe.ERAB_NbrSuccEstab_2, 0)) ERAB_NbrSuccEstab_2,
             sum(ifnull(phe.ERAB_NbrAttEstab_2, 0)) ERAB_NbrAttEstab_2,
             sum(ifnull(phe.ERAB_NbrReqRelEnb_1, 0)) ERAB_NbrReqRelEnb_1,
             sum(ifnull(phe.ERAB_NbrReqRelEnb_Normal_1, 0))
                ERAB_NbrReqRelEnb_Normal_1,
             sum(ifnull(phe.ERAB_HoFail_1, 0)) ERAB_HoFail_1,
             sum(ifnull(phe.ERAB_NbrReqRelEnb_2, 0)) ERAB_NbrReqRelEnb_2,
             sum(ifnull(phe.ERAB_NbrReqRelEnb_Normal_2, 0))
                ERAB_NbrReqRelEnb_Normal_2,
             sum(ifnull(phe.ERAB_HoFail_2, 0)) ERAB_HoFail_2,
             sum(ifnull(phe.HO_SuccOutInterEnbS1_1, 0))
                HO_SuccOutInterEnbS1_1,
             sum(ifnull(phe.HO_SuccOutInterEnbX2_1, 0))
                HO_SuccOutInterEnbX2_1,
             sum(ifnull(phe.HO_SuccOutIntraEnb_1, 0)) HO_SuccOutIntraEnb_1,
             sum(ifnull(phe.HO_AttOutInterEnbS1_1, 0)) HO_AttOutInterEnbS1_1,
             sum(ifnull(phe.HO_AttOutInterEnbX2_1, 0)) HO_AttOutInterEnbX2_1,
             sum(ifnull(phe.HO_AttOutIntraEnb_1, 0)) HO_AttOutIntraEnb_1,
             sum(ifnull(phe.PDCP_NbrPktLossUl_1, 0)) PDCP_NbrPktLossUl_1,
             sum(ifnull(phe.PDCP_NbrPktUl_1, 0)) PDCP_NbrPktUl_1,
             sum(ifnull(phe.PDCP_NbrPktLossDl_1, 0)) PDCP_NbrPktLossDl_1,
             sum(ifnull(phe.PDCP_NbrPktDl_1, 0)) PDCP_NbrPktDl_1,
             sum(ifnull(phe.PDCP_NbrPktLossUl_2, 0)) PDCP_NbrPktLossUl_2,
             sum(ifnull(phe.PDCP_NbrPktUl_2, 0)) PDCP_NbrPktUl_2,
             sum(ifnull(phe.PDCP_NbrPktLossDl_2, 0)) PDCP_NbrPktLossDl_2,
             sum(ifnull(phe.PDCP_NbrPktDl_2, 0)) PDCP_NbrPktDl_2,
             sum(ifnull(phe.PDCP_UpPktDelayDl_1, 0)) PDCP_UpPktDelayDl_1,
             count(phe.PDCP_UpPktDelayDl_1) cell_num_not_null,
             sum(ifnull(phe.ERAB_NbrFailEstab_Cause3, 0))
                ERAB_NbrFailEstab_Cause3,
             sum(ifnull(phe.ERAB_NbrFailEstab_Cause2, 0))
                ERAB_NbrFailEstab_Cause2,
             sum(ifnull(phe.ERAB_NbrFailEstab_Cause1, 0))
                ERAB_NbrFailEstab_Cause1
        FROM p_huawei_eutrancelltdd_15 phe
             LEFT JOIN dim_rc_radio_cell_4g drrc
                ON (phe.Int_Id = drrc.col_cuid)
       WHERE     phe.Start_Time >= date_add(concat(date(data_time),
                                                   ' ',
                                                   hour(data_time),
                                                   ':00:00'),
                                            INTERVAL -1 HOUR)
             AND phe.Start_Time < concat(date(data_time),
                                         ' ',
                                         hour(data_time),
                                         ':00:00')
             AND ifnull(phe.rrc_attconnestab, 0) >=
                    ifnull(phe.rrc_succconnestab, 0)
      GROUP BY 1, phe.label_cn, 3
      UNION ALL
      SELECT str_to_date(concat(date(pne.start_time),
                                ' ',
                                hour(pne.start_time),
                                ':00:00'),
                         '%Y-%m-%d %H:%i:%s')
                start_time,
             drrc.label_dev,
             pne.label_cn,
             pne.int_id,
             concat(drrc.enb_id, '-', drrc.cell_id) ecgi,
             'ŵ��' vendor,
             drrc.maintain_dept shudi,
             round(sum(ifnull(pne.PDCP_UpOctUl, 0)), 2) pdcp_up,
             round(sum(ifnull(pne.PDCP_UpOctDl, 0)), 2) pdcp_dl,
             round(
                sum(
                   ifnull(pne.PDCP_UpOctUl, 0) + ifnull(pne.PDCP_UpOctDl, 0)),
                2)
                pdcp_sum,
             round(sum(ifnull(pne.RRC_AttConnEstab, 0)), 2) rrc_attconnestab,
             round(sum(ifnull(pne.RRC_SuccConnEstab, 0)), 2)
                rrc_succconnestab,
             round(  sfb_divfloat(sum(ifnull(pne.RRC_SuccConnEstab, 0)),
                                  sum(ifnull(pne.RRC_AttConnEstab, 0)),
                                  1,
                                  1)
                   * 100,
                   2)
                rrc_succ_rate,
             round(sum(ifnull(pne.ERAB_NbrAttEstab, 0)), 2) erab_nbrattestab,
             round(sum(ifnull(pne.ERAB_NbrSuccEstab, 0)), 2)
                erab_nbrsuccestab,
             round(  sfb_divfloat(sum(ifnull(pne.ERAB_NbrSuccEstab, 0)),
                                  sum(ifnull(pne.ERAB_NbrAttEstab, 0)),
                                  1,
                                  1)
                   * 100,
                   2)
                erab_succ_rate,
             round(
                  sfb_divfloat(
                       sum(ifnull(pne.ERAB_NbrSuccEstab, 0))
                     * sum(ifnull(pne.RRC_SuccConnEstab, 0)),
                       sum(ifnull(pne.ERAB_NbrAttEstab, 0))
                     * sum(ifnull(pne.RRC_AttConnEstab, 0)),
                     1,
                     1)
                * 100,
                2)
                wireless_conn_rate,
             round(sum(ifnull(pne.CONTEXT_AttRelEnb, 0)), 2)
                context_attrelenb,
             round(sum(ifnull(pne.CONTEXT_AttRelEnb_Normal, 0)), 2)
                context_att_normal,
             round(sum(ifnull(pne.CONTEXT_SuccInitalSetup, 0)), 2)
                context_succ_init,
             round(
                  sfb_divfloat(
                     sum(
                          ifnull(pne.CONTEXT_AttRelEnb, 0)
                        - ifnull(pne.CONTEXT_AttRelEnb_Normal, 0)),
                     sum(
                          ifnull(pne.CONTEXT_SuccInitalSetup, 0)
                        + ifnull(pne.CONTEXT_NbrLeft, 0)),
                     0,
                     0)
                * 100,
                2)
                wireless_dropping_rate,
             round(sum(ifnull(pne.CONTEXT_NbrLeft, 0)), 2) CONTEXT_NbrLeft,
             round(
                  sfb_divfloat(
                     sum(
                          ifnull(pne.HO_SuccOutInterEnbS1, 0)
                        + ifnull(pne.HO_SuccOutInterEnbX2, 0)
                        + ifnull(pne.HO_SuccOutIntraEnb, 0)),
                     sum(
                          ifnull(pne.HO_AttOutInterEnbS1, 0)
                        + ifnull(pne.HO_AttOutInterEnbX2, 0)
                        + ifnull(pne.HO_AttOutIntraEnb, 0)),
                     1,
                     1)
                * 100,
                2)
                sw_succ_rate,
             avg(ifnull(pne.RRU_PuschPrbTotMeanUl, 0)) RRU_PuschPrbTotMeanUl,
             avg(ifnull(pne.RRU_PdschPrbTotMeanDl, 0)) RRU_PdschPrbTotMeanDl,
             avg(ifnull(pne.RRU_PuschPrbMeanTot, 0)) RRU_PuschPrbMeanTot,
             avg(ifnull(pne.RRU_PdschPrbMeanTot, 0)) RRU_PdschPrbMeanTot,
             avg(ifnull(pne.RRU_DtchPrbAssnMeanUl, 0)) RRU_DtchPrbAssnMeanUl,
             avg(ifnull(pne.RRU_DtchPrbAssnMeanDl, 0)) RRU_DtchPrbAssnMeanDl,
             round(  sfb_divfloat(sum(ifnull(pne.RRU_PuschPrbTotMeanUl, 0)),
                                  sum(ifnull(pne.RRU_PuschPrbMeanTot, 0)),
                                  0,
                                  0)
                   * 100,
                   2)
                u_prb_avg_use_r,
             round(  sfb_divfloat(sum(ifnull(pne.RRU_PdschPrbTotMeanDl, 0)),
                                  sum(ifnull(pne.RRU_PdschPrbMeanTot, 0)),
                                  0,
                                  0)
                   * 100,
                   2)
                d_prb_avg_use_r,
             avg(ifnull(pne.RRU_PdcchCceUtilRatio, 0)) RRU_PdcchCceUtilRatio,
             avg(ifnull(pne.RRC_ConnMean, 0)) RRC_ConnMean,
             max(ifnull(pne.RRC_ConnMax, 0)) RRC_ConnMax,
             avg(ifnull(pne.RRC_EffectiveConnMean, 0)) RRC_EffectiveConnMean,
             max(ifnull(pne.RRC_EffectiveConnMax, 0)) RRC_EffectiveConnMax,
             sum(ifnull(pne.HO_SuccOutInterEnbS1, 0)) HO_SuccOutInterEnbS1,
             sum(ifnull(pne.HO_SuccOutInterEnbX2, 0)) HO_SuccOutInterEnbX2,
             sum(ifnull(pne.HO_SuccOutIntraEnb, 0)) HO_SuccOutIntraEnb,
             sum(ifnull(pne.HO_AttOutInterEnbS1, 0)) HO_AttOutInterEnbS1,
             sum(ifnull(pne.HO_AttOutInterEnbX2, 0)) HO_AttOutInterEnbX2,
             sum(ifnull(pne.HO_AttOutIntraEnb, 0)) HO_AttOutIntraEnb,
             sum(ifnull(pne.PDCP_UpOctUl_1, 0)) PDCP_UpOctUl_1,
             sum(ifnull(pne.PDCP_UpOctDl_1, 0)) PDCP_UpOctDl_1,
             sum(ifnull(pne.ERAB_NbrMeanEstab_1, 0)) ERAB_NbrMeanEstab_1,
             sum(ifnull(pne.PDCP_UpOctUl_2, 0)) PDCP_UpOctUl_2,
             sum(ifnull(pne.PDCP_UpOctDl_2, 0)) PDCP_UpOctDl_2,
             sum(ifnull(pne.ERAB_NbrMeanEstab_2, 0)) ERAB_NbrMeanEstab_2,
             sum(ifnull(pne.ERAB_NbrSuccEstab_1, 0)) ERAB_NbrSuccEstab_1,
             sum(ifnull(pne.ERAB_NbrAttEstab_1, 0)) ERAB_NbrAttEstab_1,
             sum(ifnull(pne.ERAB_NbrSuccEstab_2, 0)) ERAB_NbrSuccEstab_2,
             sum(ifnull(pne.ERAB_NbrAttEstab_2, 0)) ERAB_NbrAttEstab_2,
             sum(ifnull(pne.ERAB_NbrReqRelEnb_1, 0)) ERAB_NbrReqRelEnb_1,
             sum(ifnull(pne.ERAB_NbrReqRelEnb_Normal_1, 0))
                ERAB_NbrReqRelEnb_Normal_1,
             sum(ifnull(pne.ERAB_HoFail_1, 0)) ERAB_HoFail_1,
             sum(ifnull(pne.ERAB_NbrReqRelEnb_2, 0)) ERAB_NbrReqRelEnb_2,
             sum(ifnull(pne.ERAB_NbrReqRelEnb_Normal_2, 0))
                ERAB_NbrReqRelEnb_Normal_2,
             sum(ifnull(pne.ERAB_HoFail_2, 0)) ERAB_HoFail_2,
             sum(ifnull(pne.HO_SuccOutInterEnbS1_1, 0))
                HO_SuccOutInterEnbS1_1,
             sum(ifnull(pne.HO_SuccOutInterEnbX2_1, 0))
                HO_SuccOutInterEnbX2_1,
             sum(ifnull(pne.HO_SuccOutIntraEnb_1, 0)) HO_SuccOutIntraEnb_1,
             sum(ifnull(pne.HO_AttOutInterEnbS1_1, 0)) HO_AttOutInterEnbS1_1,
             sum(ifnull(pne.HO_AttOutInterEnbX2_1, 0)) HO_AttOutInterEnbX2_1,
             sum(ifnull(pne.HO_AttOutIntraEnb_1, 0)) HO_AttOutIntraEnb_1,
             sum(ifnull(pne.PDCP_NbrPktLossUl_1, 0)) PDCP_NbrPktLossUl_1,
             sum(ifnull(pne.PDCP_NbrPktUl_1, 0)) PDCP_NbrPktUl_1,
             sum(ifnull(pne.PDCP_NbrPktLossDl_1, 0)) PDCP_NbrPktLossDl_1,
             sum(ifnull(pne.PDCP_NbrPktDl_1, 0)) PDCP_NbrPktDl_1,
             sum(ifnull(pne.PDCP_NbrPktLossUl_2, 0)) PDCP_NbrPktLossUl_2,
             sum(ifnull(pne.PDCP_NbrPktUl_2, 0)) PDCP_NbrPktUl_2,
             sum(ifnull(pne.PDCP_NbrPktLossDl_2, 0)) PDCP_NbrPktLossDl_2,
             sum(ifnull(pne.PDCP_NbrPktDl_2, 0)) PDCP_NbrPktDl_2,
             sum(ifnull(pne.PDCP_UpPktDelayDl_1, 0)) PDCP_UpPktDelayDl_1,
             count(pne.PDCP_UpPktDelayDl_1) cell_num_not_null,
             sum(ifnull(pne.ERAB_NbrFailEstab_Cause3, 0))
                ERAB_NbrFailEstab_Cause3,
             sum(ifnull(pne.ERAB_NbrFailEstab_Cause2, 0))
                ERAB_NbrFailEstab_Cause2,
             sum(ifnull(pne.ERAB_NbrFailEstab_Cause1, 0))
                ERAB_NbrFailEstab_Cause1
        FROM p_nuoxi_eutrancelltdd_15 pne
             LEFT JOIN dim_rc_radio_cell_4g drrc
                ON (pne.Int_Id = drrc.col_cuid)
       WHERE     pne.Start_Time >= date_add(concat(date(data_time),
                                                   ' ',
                                                   hour(data_time),
                                                   ':00:00'),
                                            INTERVAL -1 HOUR)
             AND pne.Start_Time < concat(date(data_time),
                                         ' ',
                                         hour(data_time),
                                         ':00:00')
             AND ifnull(pne.rrc_attconnestab, 0) >=
                    ifnull(pne.rrc_succconnestab, 0)
             AND ifnull(pne.ERAB_NbrAttEstab, 0) >=
                    ifnull(pne.ERAB_NbrSuccEstab, 0)
      -- AND pne.RRU_PdcchCceUtilRatio < 2
      GROUP BY 1, pne.label_cn, 3;

   COMMIT;


   INSERT INTO wire_lte_all_summary
      SELECT str_to_date(a.start_time, '%Y-%m-%d %H:%i:%s'),
             'all_hour' sum_type,
             round(sum(a.pdcp_up), 2) pdcp_up,
             round(sum(a.pdcp_dl), 2) pdcp_dl,
             round(sum(a.pdcp_sum), 2) pdcp_sum,
             sum(a.rrc_attconnestab) rrc_attconnestab,
             sum(a.rrc_succconnestab) rrc_succconnestab,
             round(  sfb_divfloat(sum(a.rrc_succconnestab),
                                  sum(a.rrc_attconnestab),
                                  1,
                                  1)
                   * 100,
                   2)
                rrc_succ_rate,
             sum(a.erab_nbrattestab) erab_nbrattestab,
             sum(a.erab_nbrsuccestab) erab_nbrsuccestab,
             round(  sfb_divfloat(sum(a.erab_nbrsuccestab),
                                  sum(a.erab_nbrattestab),
                                  1,
                                  1)
                   * 100,
                   2)
                erab_succ_rate,
             round(
                  sfb_divfloat(
                     sum(a.rrc_succconnestab) * sum(a.erab_nbrsuccestab),
                     sum(a.erab_nbrattestab) * sum(a.rrc_attconnestab),
                     1,
                     1)
                * 100,
                2)
                pdcp_succ_rate,
             sum(a.context_att) context_att,
             sum(a.context_att_normal) context_att_normal,
             sum(a.context_succ_init) context_succ_init,
             sum(a.CONTEXT_NbrLeft) CONTEXT_NbrLeft,
             round(
                  sfb_divfloat(
                     sum(a.context_att) - sum(a.context_att_normal),
                     sum(a.context_succ_init) - sum(a.CONTEXT_NbrLeft),
                     0,
                     0)
                * 100,
                2)
                pdcp_dropping_rate,
             round(
                  sfb_divfloat(
                     sum(
                          HO_SuccOutInterEnbS1
                        + HO_SuccOutInterEnbX2
                        + HO_SuccOutIntraEnb),
                     sum(
                          HO_AttOutInterEnbS1
                        + HO_AttOutInterEnbX2
                        + HO_AttOutIntraEnb),
                     1,
                     1)
                * 100,
                2)
                sw_succ_rate,
             sum(a.RRU_PuschPrbTotMeanUl) RRU_PuschPrbTotMeanUl,
             sum(a.RRU_PdschPrbTotMeanDl) RRU_PdschPrbTotMeanDl,
             sum(a.RRU_PuschPrbMeanTot) RRU_PuschPrbMeanTot,
             sum(a.RRU_PdschPrbMeanTot) RRU_PdschPrbMeanTot,
             sum(a.RRU_DtchPrbAssnMeanUl) RRU_DtchPrbAssnMeanUl,
             sum(a.RRU_DtchPrbAssnMeanDl) RRU_DtchPrbAssnMeanDl,
             round(  sfb_divfloat(sum(ifnull(a.RRU_PuschPrbTotMeanUl, 0)),
                                  sum(ifnull(a.RRU_PuschPrbMeanTot, 0)),
                                  0,
                                  0)
                   * 100,
                   2)
                u_prb_avg_use_r,
             round(  sfb_divfloat(sum(ifnull(a.RRU_PdschPrbTotMeanDl, 0)),
                                  sum(ifnull(a.RRU_PdschPrbMeanTot, 0)),
                                  0,
                                  0)
                   * 100,
                   2)
                d_prb_avg_use_r,
             avg(a.RRU_PdcchCceUtilRatio) RRU_PdcchCceUtilRatio,
             sum(a.RRC_ConnMean) RRC_ConnMean,
             sum(a.RRC_ConnMax) RRC_ConnMax,
             sum(a.RRC_EffectiveConnMean) RRC_EffectiveConnMean,
             sum(a.RRC_EffectiveConnMax) RRC_EffectiveConnMax,
             sum(a.HO_SuccOutInterEnbS1) HO_SuccOutInterEnbS1,
             sum(a.HO_SuccOutInterEnbX2) HO_SuccOutInterEnbX2,
             sum(a.HO_SuccOutIntraEnb) HO_SuccOutIntraEnb,
             sum(a.HO_AttOutInterEnbS1) HO_AttOutInterEnbS1,
             sum(a.HO_AttOutInterEnbX2) HO_AttOutInterEnbX2,
             sum(a.HO_AttOutIntraEnb) HO_AttOutIntraEnb,
             count(*) cell_num,
             ROUND(
                  SUM(
                       IFNULL(a.PDCP_UpOctUl_1, 0)
                     + IFNULL(a.PDCP_UpOctDl_1, 0))
                / 1024,
                2)
                PDCP_Oct_Sum,
             ROUND(SUM(IFNULL(a.ERAB_NbrMeanEstab_1, 0)), 2)
                ERAB_NbrMeanEstab_1,
             ROUND(
                  SUM(
                       IFNULL(a.PDCP_UpOctUl_2, 0)
                     + IFNULL(a.PDCP_UpOctDl_2, 0))
                / 1024,
                2)
                PDCP_Oct_Sum2,
             ROUND(SUM(IFNULL(a.ERAB_NbrMeanEstab_2, 0)), 2)
                ERAB_NbrMeanEstab_2,
             round(  sfb_divfloat(sum(a.ERAB_NbrSuccEstab_1),
                                  sum(a.ERAB_NbrAttEstab_1),
                                  1,
                                  1)
                   * sfb_divfloat(sum(a.RRC_SuccConnEstab),
                                  sum(a.RRC_AttConnEstab),
                                  1,
                                  1)
                   * 100,
                   2)
                vo_voice_wiresucc_r,
             round(  sfb_divfloat(sum(a.ERAB_NbrSuccEstab_2),
                                  sum(a.ERAB_NbrAttEstab_2),
                                  1,
                                  1)
                   * sfb_divfloat(sum(a.RRC_SuccConnEstab),
                                  sum(a.RRC_AttConnEstab),
                                  1,
                                  1)
                   * 100,
                   2)
                vo_video_wiresucc_r,
             ROUND(
                  sfb_divfloat(
                     SUM(
                          IFNULL(a.ERAB_NbrReqRelEnb_1, 0)
                        - IFNULL(a.ERAB_NbrReqRelEnb_Normal_1, 0)
                        + IFNULL(a.ERAB_HoFail_1, 0)),
                     SUM(IFNULL(a.ERAB_NbrSuccEstab_1, 0)),
                     0,
                     0)
                * 100,
                2)
                voice_erab_drop_r,
             ROUND(
                  sfb_divfloat(
                     SUM(
                          IFNULL(a.ERAB_NbrReqRelEnb_2, 0)
                        - IFNULL(a.ERAB_NbrReqRelEnb_Normal_2, 0)
                        + IFNULL(a.ERAB_HoFail_2, 0)),
                     SUM(IFNULL(a.ERAB_NbrSuccEstab_2, 0)),
                     0,
                     0)
                * 100,
                2)
                video_erab_drop_r,
             ROUND(
                  sfb_divfloat(
                     SUM(
                          IFNULL(a.HO_SuccOutInterEnbS1_1, 0)
                        + IFNULL(a.HO_SuccOutInterEnbX2_1, 0)
                        + IFNULL(a.HO_SuccOutIntraEnb_1, 0)),
                     SUM(
                          IFNULL(a.HO_AttOutInterEnbS1_1, 0)
                        + IFNULL(a.HO_AttOutInterEnbX2_1, 0)
                        + IFNULL(a.HO_AttOutIntraEnb_1, 0)),
                     1,
                     1)
                * 100,
                2)
                voice_switch_succ_r,
             ROUND(  sfb_divfloat(SUM(IFNULL(a.PDCP_NbrPktLossUl_1, 0)),
                                  SUM(IFNULL(a.PDCP_NbrPktUl_1, 0)),
                                  0,
                                  0)
                   * 1000000,
                   2)
                volte_ulpack_drop_r,
             ROUND(  sfb_divfloat(SUM(IFNULL(a.PDCP_NbrPktLossDl_1, 0)),
                                  SUM(IFNULL(a.PDCP_NbrPktDl_1, 0)),
                                  0,
                                  0)
                   * 1000000,
                   2)
                volte_dlpack_drop_r,
             ROUND(  sfb_divfloat(SUM(IFNULL(a.PDCP_NbrPktLossUl_2, 0)),
                                  SUM(IFNULL(a.PDCP_NbrPktUl_2, 0)),
                                  0,
                                  0)
                   * 1000000,
                   2)
                QCI2_ulpack_drop_r,
             ROUND(  sfb_divfloat(SUM(IFNULL(a.PDCP_NbrPktLossDl_2, 0)),
                                  SUM(IFNULL(a.PDCP_NbrPktDl_2, 0)),
                                  0,
                                  0)
                   * 1000000,
                   2)
                QCI2_dlpack_drop_r,
             ROUND(sfb_divfloat(SUM(IFNULL(a.PDCP_UpPktDelayDl_1, 0)),
                                SUM(IFNULL(a.cell_num_not_null, 0)),
                                0,
                                0),
                   2)
                PDCP_UpPktDelayDl_1,
             SUM(IFNULL(a.ERAB_NbrFailEstab_Cause3, 0))
                ERAB_NbrFailEstab_Cause3,
             SUM(IFNULL(a.ERAB_NbrFailEstab_Cause2, 0))
                ERAB_NbrFailEstab_Cause2,
             SUM(IFNULL(a.ERAB_NbrFailEstab_Cause1, 0))
                ERAB_NbrFailEstab_Cause1
        FROM wire_lte_unity_summary_60 a
       WHERE     a.Start_Time = date_add(concat(date(data_time),
                                                ' ',
                                                hour(data_time),
                                                ':00:00'),
                                         INTERVAL -1 HOUR)
             AND ifnull(a.rrc_attconnestab, 0) >=
                    ifnull(a.rrc_succconnestab, 0)
      GROUP BY 1;

   INSERT INTO wire_lte_all_summary
      SELECT str_to_date(p2.start_time, '%Y-%m-%d %H:%i:%s'),
             concat('scene_hour_', p1.related_sctype) sum_type,
             round(sum(p2.pdcp_up), 2) pdcp_up,
             round(sum(p2.pdcp_dl), 2) pdcp_dl,
             round(sum(p2.pdcp_sum), 2) pdcp_sum,
             sum(p2.rrc_attconnestab) rrc_attconnestab,
             sum(p2.rrc_succconnestab) rrc_succconnestab,
             round(  sfb_divfloat(sum(p2.rrc_succconnestab),
                                  sum(p2.rrc_attconnestab),
                                  1,
                                  1)
                   * 100,
                   2)
                rrc_succ_rate,
             sum(p2.erab_nbrattestab) erab_nbrattestab,
             sum(p2.erab_nbrsuccestab) erab_nbrsuccestab,
             round(  sfb_divfloat(sum(p2.erab_nbrsuccestab),
                                  sum(p2.erab_nbrattestab),
                                  1,
                                  1)
                   * 100,
                   2)
                erab_succ_rate,
             round(
                  sfb_divfloat(
                     sum(p2.rrc_succconnestab) * sum(p2.erab_nbrsuccestab),
                     sum(p2.erab_nbrattestab) * sum(p2.rrc_attconnestab),
                     1,
                     1)
                * 100,
                2)
                pdcp_succ_rate,
             sum(p2.context_att) context_att,
             sum(p2.context_att_normal) context_att_normal,
             sum(p2.context_succ_init) context_succ_init,
             sum(p2.CONTEXT_NbrLeft) CONTEXT_NbrLeft,
             round(
                  sfb_divfloat(
                     sum(p2.context_att) - sum(p2.context_att_normal),
                     sum(p2.context_succ_init) - sum(p2.CONTEXT_NbrLeft),
                     0,
                     0)
                * 100,
                2)
                pdcp_dropping_rate,
             round(
                  sfb_divfloat(
                     sum(
                          HO_SuccOutInterEnbS1
                        + HO_SuccOutInterEnbX2
                        + HO_SuccOutIntraEnb),
                     sum(
                          HO_AttOutInterEnbS1
                        + HO_AttOutInterEnbX2
                        + HO_AttOutIntraEnb),
                     1,
                     1)
                * 100,
                2)
                sw_succ_rate,
             sum(p2.RRU_PuschPrbTotMeanUl) RRU_PuschPrbTotMeanUl,
             sum(p2.RRU_PdschPrbTotMeanDl) RRU_PdschPrbTotMeanDl,
             sum(p2.RRU_PuschPrbMeanTot) RRU_PuschPrbMeanTot,
             sum(p2.RRU_PdschPrbMeanTot) RRU_PdschPrbMeanTot,
             sum(p2.RRU_DtchPrbAssnMeanUl) RRU_DtchPrbAssnMeanUl,
             sum(p2.RRU_DtchPrbAssnMeanDl) RRU_DtchPrbAssnMeanDl,
             round(  sfb_divfloat(sum(ifnull(p2.RRU_PuschPrbTotMeanUl, 0)),
                                  sum(ifnull(p2.RRU_PuschPrbMeanTot, 0)),
                                  0,
                                  0)
                   * 100,
                   2)
                u_prb_avg_use_r,
             round(  sfb_divfloat(sum(ifnull(p2.RRU_PdschPrbTotMeanDl, 0)),
                                  sum(ifnull(p2.RRU_PdschPrbMeanTot, 0)),
                                  0,
                                  0)
                   * 100,
                   2)
                d_prb_avg_use_r,
             avg(p2.RRU_PdcchCceUtilRatio) RRU_PdcchCceUtilRatio,
             sum(p2.RRC_ConnMean) RRC_ConnMean,
             sum(p2.RRC_ConnMax) RRC_ConnMax,
             sum(p2.RRC_EffectiveConnMean) RRC_EffectiveConnMean,
             sum(p2.RRC_EffectiveConnMax) RRC_EffectiveConnMax,
             sum(p2.HO_SuccOutInterEnbS1) HO_SuccOutInterEnbS1,
             sum(p2.HO_SuccOutInterEnbX2) HO_SuccOutInterEnbX2,
             sum(p2.HO_SuccOutIntraEnb) HO_SuccOutIntraEnb,
             sum(p2.HO_AttOutInterEnbS1) HO_AttOutInterEnbS1,
             sum(p2.HO_AttOutInterEnbX2) HO_AttOutInterEnbX2,
             sum(p2.HO_AttOutIntraEnb) HO_AttOutIntraEnb,
             count(*) cell_num,
             ROUND(
                  SUM(
                       IFNULL(p2.PDCP_UpOctUl_1, 0)
                     + IFNULL(p2.PDCP_UpOctDl_1, 0))
                / 1024,
                2)
                PDCP_Oct_Sum,
             ROUND(SUM(IFNULL(p2.ERAB_NbrMeanEstab_1, 0)), 2)
                ERAB_NbrMeanEstab_1,
             ROUND(
                  SUM(
                       IFNULL(p2.PDCP_UpOctUl_2, 0)
                     + IFNULL(p2.PDCP_UpOctDl_2, 0))
                / 1024,
                2)
                PDCP_Oct_Sum2,
             ROUND(SUM(IFNULL(p2.ERAB_NbrMeanEstab_2, 0)), 2)
                ERAB_NbrMeanEstab_2,
             round(  sfb_divfloat(sum(p2.ERAB_NbrSuccEstab_1),
                                  sum(p2.ERAB_NbrAttEstab_1),
                                  1,
                                  1)
                   * sfb_divfloat(sum(p2.RRC_SuccConnEstab),
                                  sum(p2.RRC_AttConnEstab),
                                  1,
                                  1)
                   * 100,
                   2)
                vo_voice_wiresucc_r,
             round(  sfb_divfloat(sum(p2.ERAB_NbrSuccEstab_2),
                                  sum(p2.ERAB_NbrAttEstab_2),
                                  1,
                                  1)
                   * sfb_divfloat(sum(p2.RRC_SuccConnEstab),
                                  sum(p2.RRC_AttConnEstab),
                                  1,
                                  1)
                   * 100,
                   2)
                vo_video_wiresucc_r,
             ROUND(
                  sfb_divfloat(
                     SUM(
                          IFNULL(p2.ERAB_NbrReqRelEnb_1, 0)
                        - IFNULL(p2.ERAB_NbrReqRelEnb_Normal_1, 0)
                        + IFNULL(p2.ERAB_HoFail_1, 0)),
                     SUM(IFNULL(p2.ERAB_NbrSuccEstab_1, 0)),
                     0,
                     0)
                * 100,
                2)
                voice_erab_drop_r,
             ROUND(
                  sfb_divfloat(
                     SUM(
                          IFNULL(p2.ERAB_NbrReqRelEnb_2, 0)
                        - IFNULL(p2.ERAB_NbrReqRelEnb_Normal_2, 0)
                        + IFNULL(p2.ERAB_HoFail_2, 0)),
                     SUM(IFNULL(p2.ERAB_NbrSuccEstab_2, 0)),
                     0,
                     0)
                * 100,
                2)
                video_erab_drop_r,
             ROUND(
                  sfb_divfloat(
                     SUM(
                          IFNULL(p2.HO_SuccOutInterEnbS1_1, 0)
                        + IFNULL(p2.HO_SuccOutInterEnbX2_1, 0)
                        + IFNULL(p2.HO_SuccOutIntraEnb_1, 0)),
                     SUM(
                          IFNULL(p2.HO_AttOutInterEnbS1_1, 0)
                        + IFNULL(p2.HO_AttOutInterEnbX2_1, 0)
                        + IFNULL(p2.HO_AttOutIntraEnb_1, 0)),
                     1,
                     1)
                * 100,
                2)
                voice_switch_succ_r,
             ROUND(  sfb_divfloat(SUM(IFNULL(p2.PDCP_NbrPktLossUl_1, 0)),
                                  SUM(IFNULL(p2.PDCP_NbrPktUl_1, 0)),
                                  0,
                                  0)
                   * 1000000,
                   2)
                volte_ulpack_drop_r,
             ROUND(  sfb_divfloat(SUM(IFNULL(p2.PDCP_NbrPktLossDl_1, 0)),
                                  SUM(IFNULL(p2.PDCP_NbrPktDl_1, 0)),
                                  0,
                                  0)
                   * 1000000,
                   2)
                volte_dlpack_drop_r,
             ROUND(  sfb_divfloat(SUM(IFNULL(p2.PDCP_NbrPktLossUl_2, 0)),
                                  SUM(IFNULL(p2.PDCP_NbrPktUl_2, 0)),
                                  0,
                                  0)
                   * 1000000,
                   2)
                QCI2_ulpack_drop_r,
             ROUND(  sfb_divfloat(SUM(IFNULL(p2.PDCP_NbrPktLossDl_2, 0)),
                                  SUM(IFNULL(p2.PDCP_NbrPktDl_2, 0)),
                                  0,
                                  0)
                   * 1000000,
                   2)
                QCI2_dlpack_drop_r,
             ROUND(sfb_divfloat(SUM(IFNULL(p2.PDCP_UpPktDelayDl_1, 0)),
                                SUM(IFNULL(p2.cell_num_not_null, 0)),
                                0,
                                0),
                   2)
                PDCP_UpPktDelayDl_1,
             SUM(IFNULL(p2.ERAB_NbrFailEstab_Cause3, 0))
                ERAB_NbrFailEstab_Cause3,
             SUM(IFNULL(p2.ERAB_NbrFailEstab_Cause2, 0))
                ERAB_NbrFailEstab_Cause2,
             SUM(IFNULL(p2.ERAB_NbrFailEstab_Cause1, 0))
                ERAB_NbrFailEstab_Cause1
        FROM c_scene_lte p1, wire_lte_unity_summary_60 p2
       WHERE     p1.ecgi = p2.ecgi
             AND p2.Start_Time = date_add(concat(date(data_time),
                                                 ' ',
                                                 hour(data_time),
                                                 ':00:00'),
                                          INTERVAL -1 HOUR)
             AND ifnull(p2.rrc_attconnestab, 0) >=
                    ifnull(p2.rrc_succconnestab, 0)
      GROUP BY 1, 2;

   COMMIT;
END;
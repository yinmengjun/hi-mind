DROP PROCEDURE IF EXISTS monitor.P_KS_WIRE_LTE_SUMMARY_QUATER;

CREATE PROCEDURE monitor.`P_KS_WIRE_LTE_SUMMARY_QUATER` ()
be:
BEGIN
   DECLARE data_time1, data_time2, data_time1_1, data_time2_2, data_time   datetime;
   DECLARE cnt1                                                            int;

SELECT 
    MAX(start_time)
INTO data_time1 FROM
    p_huawei_eutrancelltdd_15
WHERE
    start_time <= NOW();

SELECT 
    MAX(start_time)
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
    wire_lte_all_summary
WHERE
    start_time = data_time
        AND sum_type LIKE '%quater';

   IF cnt1 > 0
   THEN
      DELETE FROM wire_lte_all_summary
       WHERE start_time = data_time AND sum_type LIKE '%quater';

      COMMIT;
   END IF;

   INSERT INTO wire_lte_all_summary
      SELECT a.start_time,
             'all_quater',
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
                   (sum(a.context_att) - sum(a.context_att_normal)) * 100,
                   sum(a.context_succ_init) - sum(a.CONTEXT_NbrLeft),
                   0,
                   0),
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
                                  1,
                                  1)
                   * 100,
                   2)
                u_prb_avg_use_r,
             round(  sfb_divfloat(sum(ifnull(a.RRU_PdschPrbTotMeanDl, 0)),
                                  sum(ifnull(a.RRU_PdschPrbMeanTot, 0)),
                                  1,
                                  1)
                   * 100,
                   2)
                d_prb_avg_use_r,
             avg(a.RRU_PdcchCceUtilRatio) RRU_PdcchCceUtilRatio,
             sum(a.RRC_ConnMean) RRC_ConnMean,
             sum(a.RRC_ConnMax) RRC_ConnMax,
             sum(a.RRC_EffectiveConnMean) RRC_EffectiveConnMean,
             sum(a.RRC_EffectiveConnMax) RRC_EffectiveConnMax,
             sum(HO_SuccOutInterEnbS1) HO_SuccOutInterEnbS1,
             sum(HO_SuccOutInterEnbX2) HO_SuccOutInterEnbX2,
             sum(HO_SuccOutIntraEnb) HO_SuccOutIntraEnb,
             sum(HO_AttOutInterEnbS1) HO_AttOutInterEnbS1,
             sum(HO_AttOutInterEnbX2) HO_AttOutInterEnbX2,
             sum(HO_AttOutIntraEnb) HO_AttOutIntraEnb,
             sum(cell_num) cell_num,
             ROUND(
                  SUM(IFNULL(PDCP_UpOctUl_1, 0) + IFNULL(PDCP_UpOctDl_1, 0))
                / 1024,
                2)
                PDCP_Oct_Sum,
             ROUND(SUM(IFNULL(ERAB_NbrMeanEstab_1, 0)), 2)
                ERAB_NbrMeanEstab_1,
             ROUND(
                  SUM(IFNULL(PDCP_UpOctUl_2, 0) + IFNULL(PDCP_UpOctDl_2, 0))
                / 1024,
                2)
                PDCP_Oct_Sum2,
             ROUND(SUM(IFNULL(ERAB_NbrMeanEstab_2, 0)), 2)
                ERAB_NbrMeanEstab_2,
             round(  sfb_divfloat(sum(ERAB_NbrSuccEstab_1),
                                  sum(ERAB_NbrAttEstab_1),
                                  1,
                                  1)
                   * sfb_divfloat(sum(RRC_SuccConnEstab),
                                  sum(RRC_AttConnEstab),
                                  1,
                                  1)
                   * 100,
                   2)
                vo_voice_wiresucc_r,
             round(  sfb_divfloat(sum(ERAB_NbrSuccEstab_2),
                                  sum(ERAB_NbrAttEstab_2),
                                  1,
                                  1)
                   * sfb_divfloat(sum(RRC_SuccConnEstab),
                                  sum(RRC_AttConnEstab),
                                  1,
                                  1)
                   * 100,
                   2)
                vo_video_wiresucc_r,
             ROUND(
                  sfb_divfloat(
                     SUM(
                          IFNULL(ERAB_NbrReqRelEnb_1, 0)
                        - IFNULL(ERAB_NbrReqRelEnb_Normal_1, 0)
                        + IFNULL(ERAB_HoFail_1, 0)),
                     SUM(IFNULL(ERAB_NbrSuccEstab_1, 0)),
                     0,
                     0)
                * 100,
                2)
                voice_erab_drop_r,
             ROUND(
                  sfb_divfloat(
                     SUM(
                          IFNULL(ERAB_NbrReqRelEnb_2, 0)
                        - IFNULL(ERAB_NbrReqRelEnb_Normal_2, 0)
                        + IFNULL(ERAB_HoFail_2, 0)),
                     SUM(IFNULL(ERAB_NbrSuccEstab_2, 0)),
                     0,
                     0)
                * 100,
                2)
                video_erab_drop_r,
             ROUND(
                  sfb_divfloat(
                     SUM(
                          IFNULL(HO_SuccOutInterEnbS1_1, 0)
                        + IFNULL(HO_SuccOutInterEnbX2_1, 0)
                        + IFNULL(HO_SuccOutIntraEnb_1, 0)),
                     SUM(
                          IFNULL(HO_AttOutInterEnbS1_1, 0)
                        + IFNULL(HO_AttOutInterEnbX2_1, 0)
                        + IFNULL(HO_AttOutIntraEnb_1, 0)),
                     1,
                     1)
                * 100,
                2)
                voice_switch_succ_r,
             ROUND(  sfb_divfloat(SUM(IFNULL(PDCP_NbrPktLossUl_1, 0)),
                                  SUM(IFNULL(PDCP_NbrPktUl_1, 0)),
                                  0,
                                  0)
                   * 1000000,
                   2)
                volte_ulpack_drop_r,
             ROUND(  sfb_divfloat(SUM(IFNULL(PDCP_NbrPktLossDl_1, 0)),
                                  SUM(IFNULL(PDCP_NbrPktDl_1, 0)),
                                  0,
                                  0)
                   * 1000000,
                   2)
                volte_dlpack_drop_r,
             ROUND(  sfb_divfloat(SUM(IFNULL(PDCP_NbrPktLossUl_2, 0)),
                                  SUM(IFNULL(PDCP_NbrPktUl_2, 0)),
                                  0,
                                  0)
                   * 1000000,
                   2)
                QCI2_ulpack_drop_r,
             ROUND(  sfb_divfloat(SUM(IFNULL(PDCP_NbrPktLossDl_2, 0)),
                                  SUM(IFNULL(PDCP_NbrPktDl_2, 0)),
                                  0,
                                  0)
                   * 1000000,
                   2)
                QCI2_dlpack_drop_r,
             ROUND(sfb_divfloat(SUM(IFNULL(PDCP_UpPktDelayDl_1, 0)),
                                SUM(IFNULL(cell_num_not_null, 0)),
                                0,
                                0),
                   2)
                PDCP_UpPktDelayDl_1,
             SUM(IFNULL(ERAB_NbrFailEstab_Cause3, 0))
                ERAB_NbrFailEstab_Cause3,
             SUM(IFNULL(ERAB_NbrFailEstab_Cause2, 0))
                ERAB_NbrFailEstab_Cause2,
             SUM(IFNULL(ERAB_NbrFailEstab_Cause1, 0))
                ERAB_NbrFailEstab_Cause1
        FROM (SELECT phe.start_time start_time,
                     drrc.label_cn,
                     concat(drrc.enb_id, '-', drrc.cell_id) ecgi,
                     drrc.factory vendor,
                     drrc.maintain_dept shudi,
                     sum(ifnull(phe.PDCP_UpOctUl, 0)) pdcp_up,
                     sum(ifnull(PDCP_UpOctDl, 0)) pdcp_dl,
                     sum(
                        ifnull(phe.PDCP_UpOctUl, 0) + ifnull(PDCP_UpOctDl, 0))
                        pdcp_sum,
                     sum(ifnull(phe.RRC_AttConnEstab, 0)) rrc_attconnestab,
                     sum(ifnull(phe.RRC_SuccConnEstab, 0)) rrc_succconnestab,
                     sum(ifnull(phe.ERAB_NbrAttEstab, 0)) erab_nbrattestab,
                     sum(ifnull(phe.ERAB_NbrSuccEstab, 0)) erab_nbrsuccestab,
                     sum(ifnull(phe.CONTEXT_AttRelEnb, 0)) context_att,
                     sum(ifnull(phe.CONTEXT_AttRelEnb_Normal, 0))
                        context_att_normal,
                     sum(ifnull(phe.CONTEXT_SuccInitalSetup, 0))
                        context_succ_init,
                     sum(ifnull(phe.HO_SuccOutInterEnbS1, 0))
                        HO_SuccOutInterEnbS1,
                     sum(ifnull(phe.HO_SuccOutInterEnbX2, 0))
                        HO_SuccOutInterEnbX2,
                     sum(ifnull(phe.HO_SuccOutIntraEnb, 0))
                        HO_SuccOutIntraEnb,
                     sum(ifnull(phe.HO_AttOutInterEnbS1, 0))
                        HO_AttOutInterEnbS1,
                     sum(ifnull(phe.HO_AttOutInterEnbX2, 0))
                        HO_AttOutInterEnbX2,
                     sum(ifnull(phe.HO_AttOutIntraEnb, 0)) HO_AttOutIntraEnb,
                     sum(ifnull(phe.CONTEXT_NbrLeft, 0)) CONTEXT_NbrLeft,
                     sum(ifnull(phe.RRU_PuschPrbTotMeanUl, 0))
                        RRU_PuschPrbTotMeanUl,
                     sum(ifnull(phe.RRU_PdschPrbTotMeanDl, 0))
                        RRU_PdschPrbTotMeanDl,
                     sum(ifnull(phe.RRU_PuschPrbMeanTot, 0))
                        RRU_PuschPrbMeanTot,
                     sum(ifnull(phe.RRU_PdschPrbMeanTot, 0))
                        RRU_PdschPrbMeanTot,
                     sum(ifnull(phe.RRU_DtchPrbAssnMeanUl, 0))
                        RRU_DtchPrbAssnMeanUl,
                     sum(ifnull(phe.RRU_DtchPrbAssnMeanDl, 0))
                        RRU_DtchPrbAssnMeanDl,
                     sum(ifnull(phe.RRU_PdcchCceUtilRatio, 0))
                        RRU_PdcchCceUtilRatio,
                     sum(ifnull(phe.RRC_ConnMean, 0)) RRC_ConnMean,
                     sum(ifnull(phe.RRC_ConnMax, 0)) RRC_ConnMax,
                     sum(ifnull(phe.RRC_EffectiveConnMean, 0))
                        RRC_EffectiveConnMean,
                     sum(ifnull(phe.RRC_EffectiveConnMax, 0))
                        RRC_EffectiveConnMax,
                     count(*) cell_num,
                     sum(ifnull(phe.PDCP_UpOctUl_1, 0)) PDCP_UpOctUl_1,
                     sum(ifnull(phe.PDCP_UpOctDl_1, 0)) PDCP_UpOctDl_1,
                     sum(ifnull(phe.ERAB_NbrMeanEstab_1, 0))
                        ERAB_NbrMeanEstab_1,
                     sum(ifnull(phe.PDCP_UpOctUl_2, 0)) PDCP_UpOctUl_2,
                     sum(ifnull(phe.PDCP_UpOctDl_2, 0)) PDCP_UpOctDl_2,
                     sum(ifnull(phe.ERAB_NbrMeanEstab_2, 0))
                        ERAB_NbrMeanEstab_2,
                     sum(ifnull(phe.ERAB_NbrSuccEstab_1, 0))
                        ERAB_NbrSuccEstab_1,
                     sum(ifnull(phe.ERAB_NbrAttEstab_1, 0))
                        ERAB_NbrAttEstab_1,
                     sum(ifnull(phe.ERAB_NbrSuccEstab_2, 0))
                        ERAB_NbrSuccEstab_2,
                     sum(ifnull(phe.ERAB_NbrAttEstab_2, 0))
                        ERAB_NbrAttEstab_2,
                     sum(ifnull(phe.ERAB_NbrReqRelEnb_1, 0))
                        ERAB_NbrReqRelEnb_1,
                     sum(ifnull(phe.ERAB_NbrReqRelEnb_Normal_1, 0))
                        ERAB_NbrReqRelEnb_Normal_1,
                     sum(ifnull(phe.ERAB_HoFail_1, 0)) ERAB_HoFail_1,
                     sum(ifnull(phe.ERAB_NbrReqRelEnb_2, 0))
                        ERAB_NbrReqRelEnb_2,
                     sum(ifnull(phe.ERAB_NbrReqRelEnb_Normal_2, 0))
                        ERAB_NbrReqRelEnb_Normal_2,
                     sum(ifnull(phe.ERAB_HoFail_2, 0)) ERAB_HoFail_2,
                     sum(ifnull(phe.HO_SuccOutInterEnbS1_1, 0))
                        HO_SuccOutInterEnbS1_1,
                     sum(ifnull(phe.HO_SuccOutInterEnbX2_1, 0))
                        HO_SuccOutInterEnbX2_1,
                     sum(ifnull(phe.HO_SuccOutIntraEnb_1, 0))
                        HO_SuccOutIntraEnb_1,
                     sum(ifnull(phe.HO_AttOutInterEnbS1_1, 0))
                        HO_AttOutInterEnbS1_1,
                     sum(ifnull(phe.HO_AttOutInterEnbX2_1, 0))
                        HO_AttOutInterEnbX2_1,
                     sum(ifnull(phe.HO_AttOutIntraEnb_1, 0))
                        HO_AttOutIntraEnb_1,
                     sum(ifnull(phe.PDCP_NbrPktLossUl_1, 0))
                        PDCP_NbrPktLossUl_1,
                     sum(ifnull(phe.PDCP_NbrPktUl_1, 0)) PDCP_NbrPktUl_1,
                     sum(ifnull(phe.PDCP_NbrPktLossDl_1, 0))
                        PDCP_NbrPktLossDl_1,
                     sum(ifnull(phe.PDCP_NbrPktDl_1, 0)) PDCP_NbrPktDl_1,
                     sum(ifnull(phe.PDCP_NbrPktLossUl_2, 0))
                        PDCP_NbrPktLossUl_2,
                     sum(ifnull(phe.PDCP_NbrPktUl_2, 0)) PDCP_NbrPktUl_2,
                     sum(ifnull(phe.PDCP_NbrPktLossDl_2, 0))
                        PDCP_NbrPktLossDl_2,
                     sum(ifnull(phe.PDCP_NbrPktDl_2, 0)) PDCP_NbrPktDl_2,
                     sum(ifnull(phe.PDCP_UpPktDelayDl_1, 0))
                        PDCP_UpPktDelayDl_1,
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
               WHERE     phe.Start_Time = data_time
                     AND ifnull(phe.rrc_attconnestab, 0) >=
                            ifnull(phe.rrc_succconnestab, 0)
              GROUP BY 1
              UNION ALL
              SELECT pne.start_time start_time,
                     drrc.label_cn,
                     concat(drrc.enb_id, '-', drrc.cell_id) ecgi,
                     drrc.factory vendor,
                     drrc.maintain_dept shudi,
                     sum(ifnull(pne.PDCP_UpOctUl, 0)) pdcp_up,
                     sum(ifnull(PDCP_UpOctDl, 0)) pdcp_dl,
                     sum(
                        ifnull(pne.PDCP_UpOctUl, 0) + ifnull(PDCP_UpOctDl, 0))
                        pdcp_sum,
                     sum(ifnull(pne.RRC_AttConnEstab, 0)) rrc_attconnestab,
                     sum(ifnull(pne.RRC_SuccConnEstab, 0)) rrc_succconnestab,
                     sum(ifnull(pne.ERAB_NbrAttEstab, 0)) erab_nbrattestab,
                     sum(ifnull(pne.ERAB_NbrSuccEstab, 0)) erab_nbrsuccestab,
                     sum(ifnull(pne.CONTEXT_AttRelEnb, 0)) context_att,
                     sum(ifnull(pne.CONTEXT_AttRelEnb_Normal, 0))
                        context_att_normal,
                     sum(ifnull(pne.CONTEXT_SuccInitalSetup, 0))
                        context_succ_init,
                     sum(ifnull(pne.HO_SuccOutInterEnbS1, 0))
                        HO_SuccOutInterEnbS1,
                     sum(ifnull(pne.HO_SuccOutInterEnbX2, 0))
                        HO_SuccOutInterEnbX2,
                     sum(ifnull(pne.HO_SuccOutIntraEnb, 0))
                        HO_SuccOutIntraEnb,
                     sum(ifnull(pne.HO_AttOutInterEnbS1, 0))
                        HO_AttOutInterEnbS1,
                     sum(ifnull(pne.HO_AttOutInterEnbX2, 0))
                        HO_AttOutInterEnbX2,
                     sum(ifnull(pne.HO_AttOutIntraEnb, 0)) HO_AttOutIntraEnb,
                     sum(ifnull(pne.CONTEXT_NbrLeft, 0)) CONTEXT_NbrLeft,
                     sum(ifnull(pne.RRU_PuschPrbTotMeanUl, 0))
                        RRU_PuschPrbTotMeanUl,
                     sum(ifnull(pne.RRU_PdschPrbTotMeanDl, 0))
                        RRU_PdschPrbTotMeanDl,
                     sum(ifnull(pne.RRU_PuschPrbMeanTot, 0))
                        RRU_PuschPrbMeanTot,
                     sum(ifnull(pne.RRU_PdschPrbMeanTot, 0))
                        RRU_PdschPrbMeanTot,
                     sum(ifnull(pne.RRU_DtchPrbAssnMeanUl, 0))
                        RRU_DtchPrbAssnMeanUl,
                     sum(ifnull(pne.RRU_DtchPrbAssnMeanDl, 0))
                        RRU_DtchPrbAssnMeanDl,
                     sum(ifnull(pne.RRU_PdcchCceUtilRatio, 0))
                        RRU_PdcchCceUtilRatio,
                     sum(ifnull(pne.RRC_ConnMean, 0)) RRC_ConnMean,
                     sum(ifnull(pne.RRC_ConnMax, 0)) RRC_ConnMax,
                     sum(ifnull(pne.RRC_EffectiveConnMean, 0))
                        RRC_EffectiveConnMean,
                     sum(ifnull(pne.RRC_EffectiveConnMax, 0))
                        RRC_EffectiveConnMax,
                     count(*) cell_num,
                     sum(ifnull(pne.PDCP_UpOctUl_1, 0)) PDCP_UpOctUl_1,
                     sum(ifnull(pne.PDCP_UpOctDl_1, 0)) PDCP_UpOctDl_1,
                     sum(ifnull(pne.ERAB_NbrMeanEstab_1, 0))
                        ERAB_NbrMeanEstab_1,
                     sum(ifnull(pne.PDCP_UpOctUl_2, 0)) PDCP_UpOctUl_2,
                     sum(ifnull(pne.PDCP_UpOctDl_2, 0)) PDCP_UpOctDl_2,
                     sum(ifnull(pne.ERAB_NbrMeanEstab_2, 0))
                        ERAB_NbrMeanEstab_2,
                     sum(ifnull(pne.ERAB_NbrSuccEstab_1, 0))
                        ERAB_NbrSuccEstab_1,
                     sum(ifnull(pne.ERAB_NbrAttEstab_1, 0))
                        ERAB_NbrAttEstab_1,
                     sum(ifnull(pne.ERAB_NbrSuccEstab_2, 0))
                        ERAB_NbrSuccEstab_2,
                     sum(ifnull(pne.ERAB_NbrAttEstab_2, 0))
                        ERAB_NbrAttEstab_2,
                     sum(ifnull(pne.ERAB_NbrReqRelEnb_1, 0))
                        ERAB_NbrReqRelEnb_1,
                     sum(ifnull(pne.ERAB_NbrReqRelEnb_Normal_1, 0))
                        ERAB_NbrReqRelEnb_Normal_1,
                     sum(ifnull(pne.ERAB_HoFail_1, 0)) ERAB_HoFail_1,
                     sum(ifnull(pne.ERAB_NbrReqRelEnb_2, 0))
                        ERAB_NbrReqRelEnb_2,
                     sum(ifnull(pne.ERAB_NbrReqRelEnb_Normal_2, 0))
                        ERAB_NbrReqRelEnb_Normal_2,
                     sum(ifnull(pne.ERAB_HoFail_2, 0)) ERAB_HoFail_2,
                     sum(ifnull(pne.HO_SuccOutInterEnbS1_1, 0))
                        HO_SuccOutInterEnbS1_1,
                     sum(ifnull(pne.HO_SuccOutInterEnbX2_1, 0))
                        HO_SuccOutInterEnbX2_1,
                     sum(ifnull(pne.HO_SuccOutIntraEnb_1, 0))
                        HO_SuccOutIntraEnb_1,
                     sum(ifnull(pne.HO_AttOutInterEnbS1_1, 0))
                        HO_AttOutInterEnbS1_1,
                     sum(ifnull(pne.HO_AttOutInterEnbX2_1, 0))
                        HO_AttOutInterEnbX2_1,
                     sum(ifnull(pne.HO_AttOutIntraEnb_1, 0))
                        HO_AttOutIntraEnb_1,
                     sum(ifnull(pne.PDCP_NbrPktLossUl_1, 0))
                        PDCP_NbrPktLossUl_1,
                     sum(ifnull(pne.PDCP_NbrPktUl_1, 0)) PDCP_NbrPktUl_1,
                     sum(ifnull(pne.PDCP_NbrPktLossDl_1, 0))
                        PDCP_NbrPktLossDl_1,
                     sum(ifnull(pne.PDCP_NbrPktDl_1, 0)) PDCP_NbrPktDl_1,
                     sum(ifnull(pne.PDCP_NbrPktLossUl_2, 0))
                        PDCP_NbrPktLossUl_2,
                     sum(ifnull(pne.PDCP_NbrPktUl_2, 0)) PDCP_NbrPktUl_2,
                     sum(ifnull(pne.PDCP_NbrPktLossDl_2, 0))
                        PDCP_NbrPktLossDl_2,
                     sum(ifnull(pne.PDCP_NbrPktDl_2, 0)) PDCP_NbrPktDl_2,
                     sum(ifnull(pne.PDCP_UpPktDelayDl_1, 0))
                        PDCP_UpPktDelayDl_1,
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
               WHERE     pne.Start_Time = data_time
                     AND ifnull(pne.rrc_attconnestab, 0) >=
                            ifnull(pne.rrc_succconnestab, 0)
                     AND ifnull(pne.ERAB_NbrAttEstab, 0) >=
                            ifnull(pne.ERAB_NbrSuccEstab, 0)
              GROUP BY 1) a
      GROUP BY 1;

   COMMIT;
END;
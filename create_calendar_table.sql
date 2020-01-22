DROP TABLE rfzd_reports.calendar

CREATE TABLE rfzd_reports.calendar (
	date_id            numeric(8)  sortkey encode zstd,
	date_dt            date        encode zstd,
	date_char          varchar(10) encode zstd,
	day_num            numeric(2)  encode zstd,
	weekday            numeric(1)  encode zstd,
	month_num          numeric(2)  encode zstd,
	month_abr_enu      varchar(3)  encode zstd,
	month_abr_ptb      varchar(3)  encode zstd,
	month_abr_esn      varchar(3)  encode zstd,
	month_enu          varchar(10) encode zstd,
	month_ptb          varchar(10) encode zstd,
	month_esn          varchar(10) encode zstd,
	monthyear_abr_char varchar(5)  encode zstd,
    monthyear_char     varchar(7)  encode zstd,
    monthyear_abr_enu  varchar(6)  encode zstd,
    monthyear_abr_ptb  varchar(6)  encode zstd,
    monthyear_abr_esn  varchar(6)  encode zstd,
    monthyear_enu      varchar(15) encode zstd,
    monthyear_ptb      varchar(15) encode zstd,
    monthyear_esn      varchar(15) encode zstd,
	yearmonth          numeric(6)  encode zstd,
    year_num           numeric(4)  encode zstd
)
diststyle ALL

INSERT INTO rfzd_reports.calendar
SELECT
	to_char(dt,'YYYYMMDD'),
	dt,
	to_char(dt,'DD/MM/YYYY'),
	to_char(dt,'DD'),
	to_char(dt,'D'),
	to_char(dt,'MM'),
	left(b.enu,3),
	left(b.ptb,3),
	left(b.esn,3),
	b.enu,
	b.ptb,
	b.esn,
	to_char(dt,'MM/YY'),
	to_char(dt,'MM/YYYY'),
	to_char(dt,'YYYYMM'),
	left(b.enu,3)+'/'+to_char(dt,'YY'),
	left(b.ptb,3)+'/'+to_char(dt,'YY'),
	left(b.esn,3)+'/'+to_char(dt,'YY'),
	b.enu+'/'+to_char(dt,'YYYY'),
	b.ptb+'/'+to_char(dt,'YYYY'),
	b.esn+'/'+to_char(dt,'YYYY'),
	to_char(dt,'YYYY')
FROM
	(
		SELECT
			generate_series AS n,
			'2000-01-01' :: DATE + generate_series AS dt
		FROM
		    generate_series(0, (SELECT '2029-12-31' :: DATE - '2000-01-01' :: DATE), 1)
	) a,
	(
		SELECT  1 num, 'January'   enu, 'Janeiro'   ptb, 'Janero'     esn UNION ALL
		SELECT  2 num, 'February'  enu, 'Fevereiro' ptb, 'Febrero'    esn UNION ALL
		SELECT  3 num, 'March'     enu, 'Março'     ptb, 'Marzo'      esn UNION ALL
		SELECT  4 num, 'April'     enu, 'Abril'     ptb, 'Abril'      esn UNION ALL
		SELECT  5 num, 'May'       enu, 'Maio'      ptb, 'Mayo'       esn UNION ALL
		SELECT  6 num, 'June'      enu, 'Junho'     ptb, 'Junio'      esn UNION ALL
		SELECT  7 num, 'July'      enu, 'Julho'     ptb, 'Julio'      esn UNION ALL
		SELECT  8 num, 'August'    enu, 'Agosto'    ptb, 'Agosto'     esn UNION ALL
		SELECT  9 num, 'September' enu, 'Setembro'  ptb, 'Septiembre' esn UNION ALL
		SELECT 10 num, 'October'   enu, 'Outubro'   ptb, 'Octubre'    esn UNION ALL
		SELECT 11 num, 'November'  enu, 'Novembro'  ptb, 'Noviembre'  esn UNION ALL
		SELECT 12 num, 'December'  enu, 'Dezembro'  ptb, 'Diciembre'  esn
	) b
WHERE
	cast(to_char(dt,'MM') as numeric(2)) = b.num

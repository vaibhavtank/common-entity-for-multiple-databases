package com.demo.auth.common;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public class CommonUtil {

	public static boolean checkUserLogin() {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (!(auth instanceof AnonymousAuthenticationToken)) {
			return true;
		} else {
			return false;
		}
	}

	public static String getDateBySqlDate(final java.sql.Date sqlDate) {
		SimpleDateFormat viewFormat = new SimpleDateFormat("dd/MM/yyyy");
		String sqlDateFormat = viewFormat.format(sqlDate);
		return sqlDateFormat;
	}

	public static String getUsername() {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		return auth.getName();
	}

	public static String convertTimestampToDate(Timestamp timestamp) {
		java.util.Date date = new java.util.Date(timestamp.getTime());
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd/MM/yyyy");
		System.out.println(simpleDateFormat.format(date));
		return simpleDateFormat.format(date);
	}
	
	public static Timestamp convertStringToTimestamp(String str_date) {
		try {
			SimpleDateFormat e = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			java.util.Date date = e.parse(str_date);
			Timestamp timeStampDate = new Timestamp(date.getTime());
			return timeStampDate;
		} catch (ParseException var4) {
			System.out.println("Exception :" + var4);
			return null;
		}
	}

	public static String convertTimestampToDateInString(Timestamp timestamp) {
		java.util.Date date = new java.util.Date(timestamp.getTime());
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		System.out.println(simpleDateFormat.format(date));
		return simpleDateFormat.format(date);
	}

	public static String SetCreateOn() {
		String pattern = "yyyy-MM-dd HH:mm:ss";
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
		simpleDateFormat.setTimeZone(TimeZone.getTimeZone("Asia/Calcutta"));
		String date = simpleDateFormat.format(new java.util.Date());
		Timestamp timeStampDate = Timestamp.valueOf(date);
		return date;
	}
	
	public static String convertESTtoIST(Date estTime) throws ParseException {
		SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        dateTimeFormat.setTimeZone(TimeZone.getTimeZone("Asia/Calcutta"));
        String estDate = dateTimeFormat.format(estTime);
        return estDate;
	}
	
	public static Date convertStringtoDate(String datestr) {
		DateFormat formatter;
		Date date = null;
		formatter = new SimpleDateFormat("yyyy/MM/dd");
		try {
			date = (Date) formatter.parse(datestr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}
	
	
}

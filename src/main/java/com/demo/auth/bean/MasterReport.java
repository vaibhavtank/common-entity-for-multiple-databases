package com.demo.auth.bean;


public class MasterReport {
    private String username;
    private String reviewType;
    private Long auditId;
    private int errorCounts;
    private Float accuracy;
    private int total;
    private String miraExitDate;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getReviewType() {
        return reviewType;
    }

    public void setReviewType(String reviewType) {
        this.reviewType = reviewType;
    }

    public Long getAuditId() {
        return auditId;
    }

    public void setAuditId(Long auditId) {
        this.auditId = auditId;
    }

    public int getErrorCounts() {
        return errorCounts;
    }

    public void setErrorCounts(int errorCounts) {
        this.errorCounts = errorCounts;
    }

    public Float getAccuracy() {
        return accuracy;
    }

    public void setAccuracy(Float accuracy) {
        this.accuracy = accuracy;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public String getMiraExitDate() {
        return miraExitDate;
    }

    public void setMiraExitDate(String miraExitDate) {
        this.miraExitDate = miraExitDate;
    }
}

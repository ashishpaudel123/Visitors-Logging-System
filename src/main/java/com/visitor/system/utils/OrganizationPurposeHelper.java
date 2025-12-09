package com.visitor.system.utils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Helper class to manage organization types and their corresponding visitor purposes.
 * Each organization type has a predefined list of common purposes.
 */
public class OrganizationPurposeHelper {
    
    // Organization type constants
    public static final String BANK = "Bank";
    public static final String SCHOOL = "School";
    public static final String COLLEGE = "College";
    public static final String OFFICE = "Office";
    public static final String IT_COMPANY = "IT Company";
    public static final String GOVERNMENT_OFFICE = "Government Office";
    
    private static final Map<String, List<String>> ORGANIZATION_PURPOSES = new HashMap<>();
    
    static {
        // Bank purposes
        ORGANIZATION_PURPOSES.put(BANK, Arrays.asList(
            "Account Opening",
            "Cash Deposit",
            "Cash Withdrawal",
            "Loan Inquiry",
            "Card Issue",
            "Financial Advice",
            "Document Submission",
            "Meeting Staff",
            "Interview",
            "Delivery",
            "Maintenance",
            "Security/Inspection",
            "Other"
        ));
        
        // School purposes
        ORGANIZATION_PURPOSES.put(SCHOOL, Arrays.asList(
            "Admission Inquiry",
            "Fee Payment",
            "Student Pickup/Drop",
            "Meeting Principal",
            "Meeting Teacher",
            "Document Collection",
            "Exam Form Submission",
            "Event Participation",
            "Maintenance",
            "Delivery",
            "Inspection Visit",
            "Other"
        ));
        
        // College purposes
        ORGANIZATION_PURPOSES.put(COLLEGE, Arrays.asList(
            "Admission Inquiry",
            "Scholarship Inquiry",
            "Exam/Result Inquiry",
            "Meeting Faculty",
            "Meeting Administration",
            "Internship Discussion",
            "Document Submission",
            "Guest Lecture",
            "Maintenance",
            "Delivery",
            "Security/Inspection",
            "Other"
        ));
        
        // Office purposes
        ORGANIZATION_PURPOSES.put(OFFICE, Arrays.asList(
            "Meeting Staff",
            "Interview",
            "Client Visit",
            "Vendor Visit",
            "Delivery",
            "Maintenance",
            "HR Appointment",
            "Document Submission",
            "Audit",
            "Training/Workshop",
            "Other"
        ));
        
        // IT Company purposes
        ORGANIZATION_PURPOSES.put(IT_COMPANY, Arrays.asList(
            "Client Meeting",
            "Technical Meeting",
            "Interview",
            "Vendor Visit",
            "Hardware/Software Maintenance",
            "Delivery",
            "Project Discussion",
            "Training/Workshop",
            "Security Audit",
            "Other"
        ));
        
        // Government Office purposes
        ORGANIZATION_PURPOSES.put(GOVERNMENT_OFFICE, Arrays.asList(
            "Application Submission",
            "Document Verification",
            "Public Inquiry",
            "Meeting Officer",
            "RTI Inquiry",
            "Complaint Filing",
            "Approval/Signature",
            "Payment Services",
            "Delivery",
            "Maintenance",
            "Security/Inspection",
            "Other"
        ));
    }
    
    /**
     * Get all available organization types
     */
    public static List<String> getAllOrganizationTypes() {
        return Arrays.asList(BANK, SCHOOL, COLLEGE, OFFICE, IT_COMPANY, GOVERNMENT_OFFICE);
    }
    
    /**
     * Get purposes for a specific organization type
     */
    public static List<String> getPurposesForOrganization(String organizationType) {
        List<String> purposes = ORGANIZATION_PURPOSES.get(organizationType);
        return purposes != null ? new ArrayList<>(purposes) : new ArrayList<>();
    }
    
    /**
     * Check if an organization type is valid
     */
    public static boolean isValidOrganizationType(String organizationType) {
        return organizationType != null && ORGANIZATION_PURPOSES.containsKey(organizationType);
    }
}

package com.visitor.system.utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

/**
 * EmailUtil - Utility class for sending emails using SMTP
 * 
 * Configuration Instructions:
 * 1. For Gmail: Enable 2-factor authentication
 * 2. Generate App Password: https://myaccount.google.com/apppasswords
 * 3. Update the EMAIL and PASSWORD constants below
 * 4. For other providers, update SMTP settings accordingly
 */
public class EmailUtil {
    
    // EMAIL CONFIGURATION - UPDATE THESE VALUES
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL = "ashishpaudel206058@gmail.com"; // Change this to your email
    private static final String PASSWORD = "xvfk ldom sxyr pclf"; // Change this to your Gmail App Password
    private static final String FROM_NAME = "Visitor Entry System";
    
    /**
     * Sends a password reset email to the specified recipient
     * 
     * @param toEmail Recipient's email address
     * @param resetLink The password reset link with token
     * @param adminUsername The username of the admin requesting reset
     * @return true if email sent successfully, false otherwise
     */
    public static boolean sendPasswordResetEmail(String toEmail, String resetLink, String adminUsername) {
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", SMTP_HOST);
        properties.put("mail.smtp.port", SMTP_PORT);
        properties.put("mail.smtp.ssl.protocols", "TLSv1.2");
        
        // Create authenticator
        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL, PASSWORD);
            }
        };
        
        Session session = Session.getInstance(properties, auth);
        
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL, FROM_NAME));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Password Reset Request - Visitor Entry System");
            
            // HTML email body
            String htmlContent = buildEmailHTML(adminUsername, resetLink);
            message.setContent(htmlContent, "text/html; charset=utf-8");
            
            // Send email
            Transport.send(message);
            System.out.println("Password reset email sent successfully to: " + toEmail);
            return true;
            
        } catch (Exception e) {
            System.err.println("Failed to send email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Builds the HTML content for the password reset email
     */
    private static String buildEmailHTML(String username, String resetLink) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<style>" +
                "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
                ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
                ".header { background: #4CAF50; color: white; padding: 20px; text-align: center; }" +
                ".content { padding: 30px; background: #f9f9f9; }" +
                ".button { display: inline-block; padding: 12px 30px; background: #4CAF50; color: white; " +
                "text-decoration: none; border-radius: 5px; margin: 20px 0; }" +
                ".footer { padding: 20px; text-align: center; color: #666; font-size: 12px; }" +
                ".warning { color: #d32f2f; font-weight: bold; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>Password Reset Request</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<p>Hello <strong>" + username + "</strong>,</p>" +
                "<p>We received a request to reset your password for the Visitor Entry System.</p>" +
                "<p>Click the button below to reset your password:</p>" +
                "<p style='text-align: center;'>" +
                "<a href='" + resetLink + "' class='button'>Reset Password</a>" +
                "</p>" +
                "<p>Or copy and paste this link into your browser:</p>" +
                "<p style='word-break: break-all; background: white; padding: 10px; border: 1px solid #ddd;'>" +
                resetLink +
                "</p>" +
                "<p class='warning'>⚠️ This link will expire in 30 minutes.</p>" +
                "<p>If you didn't request a password reset, please ignore this email or contact support if you have concerns.</p>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>This is an automated email from Visitor Entry System. Please do not reply.</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }
    
    /**
     * Sends a simple test email to verify configuration
     * 
     * @param toEmail Test recipient email
     * @return true if test email sent successfully
     */
    public static boolean sendTestEmail(String toEmail) {
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", SMTP_HOST);
        properties.put("mail.smtp.port", SMTP_PORT);
        properties.put("mail.smtp.ssl.protocols", "TLSv1.2");
        
        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL, PASSWORD);
            }
        };
        
        Session session = Session.getInstance(properties, auth);
        
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL, FROM_NAME));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Test Email - Visitor Entry System");
            message.setText("This is a test email. Your email configuration is working correctly!");
            
            Transport.send(message);
            System.out.println("Test email sent successfully!");
            return true;
            
        } catch (Exception e) {
            System.err.println("Test email failed: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}

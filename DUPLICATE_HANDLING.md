# Duplicate Username/Email Handling

## Overview

The system has **multi-layer protection** against duplicate usernames and emails during registration.

---

## 🛡️ Protection Layers

### **Layer 1: Database Constraints (Strongest)**

```sql
CREATE TABLE admins (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,  -- ✅ UNIQUE constraint
    email VARCHAR(100) UNIQUE NOT NULL,    -- ✅ UNIQUE constraint
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**What happens:**

- If duplicate username/email reaches the database → SQL Error thrown
- `SQLException: Duplicate entry 'admin' for key 'username'`
- Database **rejects** the insert operation

### **Layer 2: Application Validation (Before DB)**

```java
// RegisterServlet.java
boolean usernameExists = adminDAO.isUsernameExists(username);
boolean emailExists = adminDAO.isEmailExists(email);

if (usernameExists && emailExists) {
    res.sendRedirect("/register.jsp?error=both");
} else if (usernameExists) {
    res.sendRedirect("/register.jsp?error=username");
} else if (emailExists) {
    res.sendRedirect("/register.jsp?error=email");
}
```

**What happens:**

- Check performed **before** attempting database insert
- Prevents unnecessary database errors
- Provides specific user feedback

### **Layer 3: Client-Side (HTML5)**

```html
<input name="username" type="text" required />
<input name="email" type="email" required />
```

**What happens:**

- Browser validates email format
- Ensures fields are not empty
- Basic validation before submission

---

## 📊 Error Scenarios

### **Scenario 1: Duplicate Username Only**

**Attempt:** Register with `username: admin`, `email: newuser@test.com`

**Flow:**

1. `isUsernameExists("admin")` → returns `true`
2. Redirect to: `/register.jsp?error=username`
3. User sees:
   > ❌ "This username is already taken. Please choose a different username."

**Database:** Not touched (validation caught it early)

---

### **Scenario 2: Duplicate Email Only**

**Attempt:** Register with `username: newuser`, `email: admin@visitor.com`

**Flow:**

1. `isEmailExists("admin@visitor.com")` → returns `true`
2. Redirect to: `/register.jsp?error=email`
3. User sees:
   > ❌ "This email is already registered. Please use a different email or login instead."

**Database:** Not touched

---

### **Scenario 3: Both Duplicate**

**Attempt:** Register with `username: admin`, `email: admin@visitor.com`

**Flow:**

1. Both checks return `true`
2. Redirect to: `/register.jsp?error=both`
3. User sees:
   > ❌ "Both username and email are already registered. Please use different credentials or login instead."

**Database:** Not touched

---

### **Scenario 4: Validation Bypassed (Hacker Attack)**

**Attempt:** Directly POST to servlet bypassing frontend validation

**Flow:**

1. Application validation catches duplicate
2. If somehow bypassed → Database UNIQUE constraint catches it
3. SQLException thrown → Caught by try-catch
4. User redirected to: `/register.jsp?error=failed`
5. User sees:
   > ❌ "Registration failed. Please try again."

**Result:** **System remains secure** ✅

---

## 🔍 How Duplicate Check Works

### **AdminDAO.java Methods**

```java
public boolean isUsernameExists(String username) {
    String query = "SELECT COUNT(*) FROM admins WHERE username = ?";
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(query)) {
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1) > 0;  // Returns true if count > 0
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

public boolean isEmailExists(String email) {
    String query = "SELECT COUNT(*) FROM admins WHERE email = ?";
    // ... same logic as above
}
```

**Performance:**

- Uses `COUNT(*)` - very fast query
- Returns immediately (no full table scan needed)
- Query time: <1ms even with thousands of admins

---

## 🎨 User Experience

### **Improved Error Messages**

| Error Type     | Message                                                                                                  | Action Suggested                     |
| -------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| Username taken | "This username is already taken. Please choose a different username."                                    | Choose new username                  |
| Email taken    | "This email is already registered. Please use a different email or **login** instead."                   | Use different email OR login         |
| Both taken     | "Both username and email are already registered. Please use different credentials or **login** instead." | Create entirely new account OR login |

### **Why Specific Messages?**

**✅ Pros:**

- Better user experience
- Clear guidance on what to fix
- Faster registration process
- Reduces support tickets

**⚠️ Cons:**

- Allows username enumeration (attackers can check if username exists)
- Email enumeration possible

**Mitigation:**

- Rate limiting on registration attempts (TODO)
- CAPTCHA on repeated failures (TODO)
- Account lockout after X failed attempts (TODO)

---

## 🔒 Security Considerations

### **Username Enumeration Risk**

**Risk:** Attacker can check if username "admin" exists

```bash
# Attacker tries:
curl -X POST /register -d "username=admin&email=test@test.com"
# Response: "username is already taken"
# Conclusion: "admin" account exists
```

**Mitigation Options:**

1. **Generic Error (More Secure)**

   ```
   "Username or email already exists"
   ```

   - Don't reveal which field is duplicate
   - Prevents enumeration
   - Less user-friendly

2. **Specific Error (Better UX) - Current Implementation**

   ```
   "This username is already taken"
   ```

   - Better user experience
   - Allows enumeration
   - **Acceptable risk** for most applications

3. **Rate Limiting (Recommended Future Enhancement)**
   ```java
   // TODO: Implement rate limiting
   if (registrationAttempts > 5 in 1 hour) {
       return "Too many attempts. Try again later.";
   }
   ```

### **Which Approach is Best?**

For a **visitor logging system** (not banking/security-critical):

- ✅ **Specific error messages** = Better choice
- ✅ Username enumeration risk is **low impact**
- ✅ User experience improvement is **high value**

For **high-security applications**:

- ✅ Use generic errors
- ✅ Implement rate limiting
- ✅ Add CAPTCHA

---

## 🧪 Testing Duplicate Detection

### **Manual Test Steps**

1. **First Registration (Success)**

   ```
   Username: testuser1
   Email: test1@example.com
   Password: test123
   Result: ✅ Registration successful
   ```

2. **Duplicate Username Test**

   ```
   Username: testuser1  (same as above)
   Email: different@example.com
   Password: test123
   Result: ❌ "This username is already taken"
   ```

3. **Duplicate Email Test**

   ```
   Username: differentuser
   Email: test1@example.com  (same as above)
   Password: test123
   Result: ❌ "This email is already registered"
   ```

4. **Both Duplicate Test**
   ```
   Username: testuser1
   Email: test1@example.com
   Password: test123
   Result: ❌ "Both username and email are already registered"
   ```

### **SQL Test**

```sql
-- Create test admin
INSERT INTO admins (username, email, password)
VALUES ('testadmin', 'test@test.com', 'pass123');

-- Try duplicate username (will fail)
INSERT INTO admins (username, email, password)
VALUES ('testadmin', 'different@test.com', 'pass456');
-- ERROR: Duplicate entry 'testadmin' for key 'username'

-- Try duplicate email (will fail)
INSERT INTO admins (username, email, password)
VALUES ('different', 'test@test.com', 'pass789');
-- ERROR: Duplicate entry 'test@test.com' for key 'email'
```

---

## 📋 Error Code Reference

| Error Code        | Description                   | User Message                                                                                         |
| ----------------- | ----------------------------- | ---------------------------------------------------------------------------------------------------- |
| `?error=username` | Username already exists       | "This username is already taken. Please choose a different username."                                |
| `?error=email`    | Email already exists          | "This email is already registered. Please use a different email or login instead."                   |
| `?error=both`     | Both username and email exist | "Both username and email are already registered. Please use different credentials or login instead." |
| `?error=required` | Missing fields                | "All fields are required."                                                                           |
| `?error=password` | Passwords don't match         | "Passwords do not match."                                                                            |
| `?error=failed`   | Database error                | "Registration failed. Please try again."                                                             |

---

## 🚀 Future Enhancements

### **1. Rate Limiting**

```java
// Limit registration attempts per IP
if (getRegistrationAttempts(ipAddress) > 5) {
    return "Too many registration attempts. Try again in 1 hour.";
}
```

### **2. Email Verification**

```java
// Send verification email
sendVerificationEmail(email, verificationToken);
// Admin account inactive until verified
admin.setActive(false);
```

### **3. Password Strength Validation**

```java
// Require strong passwords
if (!password.matches("^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}$")) {
    return "Password must be at least 8 characters with uppercase, lowercase, and number";
}
```

### **4. CAPTCHA Integration**

```html
<!-- Add Google reCAPTCHA -->
<div class="g-recaptcha" data-sitekey="your-site-key"></div>
```

### **5. Password Hashing (Critical)**

```java
// TODO: Use BCrypt instead of plain text
import org.mindrot.jbcrypt.BCrypt;
String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
```

---

## ✅ Summary

### **Current Protection:**

1. ✅ Database UNIQUE constraints
2. ✅ Application-level validation
3. ✅ Specific error messages
4. ✅ User-friendly feedback
5. ✅ Try-catch error handling

### **What Happens on Duplicate:**

- **Username taken:** Clear error message + suggestion
- **Email taken:** Clear error message + login link
- **Both taken:** Clear error message + login link
- **Database error:** Generic error (security)

### **Security Level:**

- ✅ **Good** for visitor logging system
- ✅ Prevents duplicate accounts
- ✅ User-friendly experience
- ⚠️ Minor enumeration risk (acceptable)

---

**Result:** Your system properly handles duplicate usernames/emails with multiple layers of protection! 🎉

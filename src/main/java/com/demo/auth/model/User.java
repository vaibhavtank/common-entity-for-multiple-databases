package com.demo.auth.model;

import javax.persistence.*;
import javax.persistence.Entity;

import java.util.Set;

@Entity
@Table(name = "userdemo")
public class User extends com.demo.auth.model.Entity<Long, User> {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "id", unique = true, nullable = false)
    @SequenceGenerator(name = "user_seq",
            sequenceName = "user_seq", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.AUTO,
            generator = "user_seq")

	/*@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", unique = true, nullable = false)
    @TableGenerator(name = "TABLE_GEN", table = "SEQUENCER", pkColumnName = "SEQ_NAME", valueColumnName = "SEQ_COUNT", pkColumnValue = "USER_SEQ_NEXT_VAL")*/
    private Long id;

    private String username;

    private String password;

    @Transient
    private String passwordConfirm;

    @ManyToMany
    private Set<Role> roles;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPasswordConfirm() {
        return passwordConfirm;
    }

    public void setPasswordConfirm(String passwordConfirm) {
        this.passwordConfirm = passwordConfirm;
    }

    public Set<Role> getRoles() {
        return roles;
    }

    public void setRoles(Set<Role> roles) {
        this.roles = roles;
    }
}

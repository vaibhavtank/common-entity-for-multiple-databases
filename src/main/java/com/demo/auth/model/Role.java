package com.demo.auth.model;

import javax.persistence.*;
import javax.persistence.Entity;
import java.util.Set;

@Entity
@Table(name = "roledemo")
public class Role extends com.demo.auth.model.Entity<Long, Role> {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "id", unique = true, nullable = false)
    @SequenceGenerator(name = "role_seq",
            sequenceName = "role_seq", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.AUTO,
            generator = "role_seq")

	/*@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", unique = true, nullable = false)
    @TableGenerator(name = "TABLE_GEN", table = "SEQUENCER", pkColumnName = "SEQ_NAME", valueColumnName = "SEQ_COUNT", pkColumnValue = "ROLE_SEQ_NEXT_VAL")*/
    private Long id;

    private String name;

    @ManyToMany(mappedBy = "roles")
    private Set<User> users;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Set<User> getUsers() {
        return users;
    }

    public void setUsers(Set<User> users) {
        this.users = users;
    }
}

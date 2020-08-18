package com.demo.auth.model;



import java.io.Serializable;
import java.sql.Timestamp;
import java.text.Collator;
import java.util.Locale;

import javax.persistence.Column;
import javax.persistence.MappedSuperclass;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;

import org.hibernate.Hibernate;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

@MappedSuperclass
public abstract class Entity<K extends Serializable & Comparable<K>, E extends Entity<K, ?>>
		implements Serializable, Comparable<E> {

	private static final long serialVersionUID = -3988499137919577054L;

	public static final Collator DEFAULT_STRING_COLLATOR = Collator.getInstance(Locale.ENGLISH);

	static {
		DEFAULT_STRING_COLLATOR.setStrength(Collator.PRIMARY);
	}

	public abstract K getId();

	public abstract void setId(K id);

	@Column(name = "CREATED_DATE", nullable = true, updatable = false)
	private Timestamp createdDate;

	@Column(name = "CREATED_BY", nullable = true, updatable = false)
	private String createdBy;

	@Column(name = "UPDATE_DATE", nullable = true)
	private Timestamp updatedDate;

	@Column(name = "UPDATE_BY", nullable = true)
	private String updatedBy;

	@PrePersist
	private void onCreatedDate() {
		this.createdDate = new Timestamp(System.currentTimeMillis());
		this.updatedDate = this.createdDate;
		String createdBy = getUsernameByAuthentication();
		this.createdBy = createdBy;
		this.updatedBy = createdBy;
	}

	@PreUpdate
	private void onUpdatedDate() {
		this.updatedDate = new Timestamp(System.currentTimeMillis());
		String updatedBy = getUsernameByAuthentication();
		this.updatedBy = updatedBy;
	}

	private String getUsernameByAuthentication() {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null && !(auth instanceof AnonymousAuthenticationToken)) {
			return auth.getName();
		} else {
			return null;
		}
	}

	public Timestamp getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Timestamp createdDate) {
		this.createdDate = createdDate;
	}

	public String getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}

	public Timestamp getUpdatedDate() {
		return updatedDate;
	}

	public void setUpdatedDate(Timestamp updatedDate) {
		this.updatedDate = updatedDate;
	}

	public String getUpdatedBy() {
		return updatedBy;
	}

	public void setUpdatedBy(String updatedBy) {
		this.updatedBy = updatedBy;
	}

	/**
	 * Indicates whether the object has been persisted or not
	 * 
	 * @return True if the object has not yet been persisted
	 */
	public boolean isNew() {
		return getId() == null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public boolean equals(Object object) {
		if (object == null) {
			return false;
		}
		if (object == this) {
			return true;
		}

		// The object can be proxyfied so we use Hibernate.getClass () to output
		// the true class
		if (Hibernate.getClass(object) != Hibernate.getClass(this)) {
			return false;
		}
		// NOSONAR: treated above but wrapper Hibernate
		Entity<K, E> entity = (Entity<K, E>) object;
		K id = getId();

		if (id == null) {
			return false;
		}
		return id.equals(entity.getId());
	}

	@Override
	public int hashCode() {
		int hash = 7;
		K id = getId();
		hash = 31 * hash + ((id == null) ? 0 : id.hashCode());
		return hash;
	}

	public int compareTo(E o) {
		if (this == o) {
			return 0;
		}
		return this.getId().compareTo(o.getId());
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("entity.");
		builder.append(Hibernate.getClass(this).getSimpleName());
		builder.append("<");
		builder.append(getId());
		builder.append("-");
		builder.append(super.toString());
		builder.append(">");
		return builder.toString();
	}
}

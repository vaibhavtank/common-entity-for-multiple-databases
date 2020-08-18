package com.demo.auth.common;


import java.io.Serializable;
import java.lang.reflect.ParameterizedType;
import java.util.List;

import com.demo.auth.model.Entity;
import org.hibernate.service.spi.ServiceException;
import org.springframework.data.jpa.repository.JpaRepository;


public abstract class EntityServiceImpl<K extends Serializable & Comparable<K>, E extends Entity<K, ?>>
		implements EntityService<K, E> {

	
	private Class<E> objectClass;

	private JpaRepository<E, K> repository;

	@SuppressWarnings("unchecked")
	public EntityServiceImpl(JpaRepository<E, K> repository) {
		ParameterizedType genericSuperclass = (ParameterizedType) getClass().getGenericSuperclass();
		this.objectClass = (Class<E>) genericSuperclass.getActualTypeArguments()[1];
		this.repository = repository;
	}

	public final Class<E> getObjectClass() {
		return objectClass;
	}

	public E getById(K id) {
		return repository.findOne(id);
	}

	public void save(E entity) throws ServiceException {
		repository.saveAndFlush(entity);
	}

	public void create(E entity) throws ServiceException {
		save(entity);
	}

	public final void update(E entity) throws ServiceException {
		save(entity);
	}

	public void delete(E entity) throws ServiceException {
		repository.delete(entity);
	}

	public void flush() {
		repository.flush();
	}

	public List<E> list() {
		return repository.findAll();
	}

	public Long count() {
		return repository.count();
	}
	
	public Long saveReturnID(E entity) throws ServiceException {
		E e = repository.saveAndFlush(entity);
		return (Long) e.getId();
	}
	
	public E saveReturnEntity(E entity) throws ServiceException {
		E e = repository.saveAndFlush(entity);
		return e;
	}


}
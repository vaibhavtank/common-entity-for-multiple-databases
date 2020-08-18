package com.demo.auth.common;

import java.io.Serializable;
import java.util.List;

import com.demo.auth.model.Entity;
import org.hibernate.service.spi.ServiceException;

public interface EntityService<K extends Serializable & Comparable<K>, E extends Entity<K, ?>>
extends TransactionalAspectAwareService {

/**
* Crée l'entité dans la base de données. Mis à part dans les tests pour
* faire des sauvegardes simples, utiliser create() car il est possible
* qu'il y ait des listeners sur la création d'une entité.
* 
* @param entity ***entité**.
* @throws ServiceException  **ServiceException**.
*/
void save(E entity) throws ServiceException;

/**
* Met à jour l'entité dans la base de données.
* 
* @param entity **entité**.
* @throws ServiceException  **ServiceException**.
*/
void update(E entity) throws ServiceException;

/**
* Crée l'entité dans la base de données.
*
* @param entity **entité**.
* @throws ServiceException  **ServiceException**.
*/
void create(E entity) throws ServiceException;

/**
* Supprime l'entité de la base de données
*
* @param entity **entité**.
* @throws ServiceException  **ServiceException**.
*/
void delete(E entity) throws ServiceException;

/**
* Retourne une entité à partir de son id.
* 
* @param id **identifiant**.
*
* @return entité **entire**.
*/
E getById(K id);

/**
* Renvoie la liste de l'ensemble des entités de ce type.
* 
* @return liste d'entités
*/
List<E> list();

/**
* Compte le nombre d'entités de ce type présentes dans la base.
* 
* @return nombre d'entités
*/
Long count();

/**
* Flushe la session.
*/
void flush();

/**
* Crée l'entité dans la base de données. Mis à part dans les tests pour
* faire des sauvegardes simples, utiliser create() car il est possible
* qu'il y ait des listeners sur la création d'une entité.
*
* @param entity **entité**.
* @return nombre d'entités
* @throws ServiceException  **ServiceException**.
*/
Long saveReturnID(E entity) throws ServiceException;

/**
* Crée l'entité dans la base de données. Mis à part dans les tests pour
* faire des sauvegardes simples, utiliser create() car il est possible
* qu'il y ait des listeners sur la création d'une entité.
*
* @param entity **entité**.
* @return entité **entire**.
* @throws ServiceException  **ServiceException**.
*/
E saveReturnEntity(E entity) throws ServiceException;
}

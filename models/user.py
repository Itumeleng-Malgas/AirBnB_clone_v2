#!/usr/bin/python3
"""This module defines a class User"""
from models.base_model import BaseModel, Base
from sqlalchemy import Column, String
from sqlalchemy.orm import relationship
from os import getenv


class User(BaseModel, Base):
    """
    This class defines a user by various attributes
    which will be mapped to columns on a users table
    in the database
    """
    __tablename__ = "users"
    email = Column(String(128), nullable=False)
    password = Column(String(128), nullable=False)
    first_name = Column(String(128), nullable=True)
    last_name = Column(String(128), nullable=True)

    if getenv('HBNB_TYPE_STORAGE') == 'db':
        # establishing relationship with place and city models
        places = relationship(
            "Place", backref="user", cascade="all, delete-orphan")
        reviews = relationship(
            "Review", backref="user", cascade="all, delete-orphan")

---
title: "Java"
layout: archive
permalink: categories/java
author_profile: true
sidebar_main: true
---

{% assign posts = site.tags.spring %}
{% for post in posts %} 
    {% include archive-single2.html type=page.entries_layout %}
{% endfor %}


{% assign posts = site.tags.GOF %}
{% for post in posts %} 
    {% include archive-single2.html type=page.entries_layout %}
{% endfor %}

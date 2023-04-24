---
title: "Django"
layout: archive
permalink: tags/django
author_profile: true
sidebar_main: true
---

{% assign posts = site.tags.django %}
{% for post in posts %} 
    {% include archive-single2.html type=page.entries_layout %}
{% endfor %}
---
title: "APP 이론"
layout: archive
permalink: categories/appbasic
author_profile: true
sidebar_main: true
---

{% assign posts = site.categories.appbasic %}
{% for post in posts %} {% include archive-single2.html type=page.entries_layout %} {% endfor %}
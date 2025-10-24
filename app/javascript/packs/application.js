import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "@fortawesome/fontawesome-free/css/all";

import 'jquery'
import 'popper.js'
import 'bootstrap'

import "./books"
import "./modals"
import "./compilation_collapse"

import '../stylesheets/application'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

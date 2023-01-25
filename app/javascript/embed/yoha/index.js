import Cookies from "./cookies";

const yoha = window.yoha || window.Yoha || {};

const config = {
  urlPrefix: "",
  visitsUrl: "http://localhost:5150/u/c/visits",
  identifyUrl: "http://localhost:5150/u/c/identify",
  eventsUrl: "http://localhost:5150/u/c/events",
  cookies: true,
  cookieDomain: null,
  visitDuration: 4 * 60, // default 4 hours
  visitorDuration: 2 * 365 * 24 * 60, // default 2 years
};

yoha.configure = function (options) {
  for (const key in options) {
    if (options.hasOwnProperty(key)) {
      config[key] = options[key];
    }
  }
};

yoha.configure(yoha);

const $ = window.jQuery || window.Zepto || window.$;
let visitId;
let visitorId;
let track;
const isReady = false;
const queue = [];
const canStringify =
  typeof JSON !== "undefined" && typeof JSON.stringify !== "undefined";
const eventQueue = [];

// cookies

function setCookie(name, value, ttl) {
  Cookies.set(name, value, ttl, config.cookieDomain || config.domain);
}

function getCookie(name) {
  return Cookies.get(name);
}

function destroyCookie(name) {
  Cookies.set(name, "", -1);
}

function log(message) {
  if (getCookie("_debug")) {
    window.console.log(message);
  }
}

function documentReady(callback) {
  if (
    document.readyState === "interactive" ||
    document.readyState === "complete"
  ) {
    setTimeout(callback, 0);
  } else {
    document.addEventListener("DOMContentLoaded", callback);
  }
}

function generateId() {
  return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, (c) => {
    const r = (Math.random() * 16) | 0;
    const v = c == "x" ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

yoha.createVisit = async (surveyId) => {
  visitId = yoha.getVisitId();
  visitorId = yoha.getVisitorId();
  track = getCookie("yoha_track");

  if (!visitId) {
    visitId = generateId();
    setCookie("yoha_visit", visitId, config.visitDuration);
  }

  // make sure cookies are enabled
  if (getCookie("yoha_visit")) {
    log("Visit started");

    if (!visitorId) {
      visitorId = generateId();
      setCookie("yoha_visitor", visitorId, config.visitorDuration);
    }
    const data = {
      visit_token: visitId,
      visitor_token: visitorId,
      landing_page: window.location.href,
      path: window.location.pathname,
      screen_width: window.screen.width,
      screen_height: window.screen.height,
      js: true,
    };

    // referrer
    if (document.referrer.length > 0) {
      data.referrer = document.referrer;
    }

    let url = config.visitsUrl;
    if (window?.Userveys?.setup?.id != null) {
      url = `${url}/${window.Userveys.setup.id}`;
    }
    await sendRequest(url, { tracking: data });
  }
};

yoha.createEvent = async (event) => {
  if (window?.Userveys?.setup?.id == null) {
    console.error("Must be associated with a survey to track an event");
    return;
  }
  const surveyId = window?.Userveys?.setup?.id;
  const url = `${config.eventsUrl}/${window.Userveys.setup.id}`;
  visitorId = yoha.getVisitorId();
  console.log("event", visitorId, surveyId, {
    visitor_token: visitId,
    event,
  });
  const response = await sendRequest(url, { visitor_token: visitId, event });

  if (!response.ok) {
    const message = `An error has occured: ${response.status}`;
    throw new Error(message);
  }
};

yoha.identify = async (data) => {
  visitorId = yoha.getVisitorId();
  console.log("identify with", visitorId, data);

  const url = `${config.identifyUrl}/${visitorId}`;

  const response = await sendRequest(url, data);

  if (!response.ok) {
    const message = `An error has occured: ${response.status}`;
    throw new Error(message);
  }
  // id: 'USER-ID-ABC-123', // The ID of your user
  // email: 'jane@awesome.com', // Provide their email address (optional)
  // name: 'Jane Doe', // The full name of the user (optional)
};

const sendRequest = async (url = config.visitsUrl, data) =>
  await fetch(url, {
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
    },
    body: JSON.stringify(data),
  });

function page() {
  return config.page || window.location.pathname;
}

yoha.getVisitId = yoha.getVisitToken = function () {
  return getCookie("yoha_visit");
};

yoha.getVisitorId = yoha.getVisitorToken = function () {
  return getCookie("yoha_visitor");
};

yoha.reset = function () {
  destroyCookie("yoha_visit");
  destroyCookie("yoha_visitor");
  destroyCookie("yoha_events");
  destroyCookie("yoha_track");
  return true;
};

yoha.debug = function (enabled) {
  if (enabled === false) {
    destroyCookie("_debug");
  } else {
    setCookie("_debug", "t", 365 * 24 * 60); // 1 year
  }
  return true;
};

yoha.start = function () {
  // createVisit();

  yoha.start = function () {};
};

documentReady(() => {
  yoha.start();
});

export default yoha;

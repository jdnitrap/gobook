// EXPERIMENTAL / UNVERIFIED.
//
// Two independent things happen in this theme:
//
// 1. Normal sign-in, driven by the greeter's `window.lightdm` bridge object.
//    The method/event names used below (authenticate, respond, show_prompt,
//    show_message, authentication_complete, start_session) follow the API
//    shape documented for web-greeter/nody-greeter themes, reproduced from
//    memory rather than confirmed against the live web-greeter-types
//    package — verify these against the real API on a test machine and
//    adjust names here if they differ.
//
// 2. Account creation, which does NOT go through `window.lightdm` at all
//    (the greeter bridge has no such concept, and shouldn't — creating a
//    Unix account needs root). Instead the form POSTs to a small localhost
//    helper service (see basic/user-create-helper.nix) that runs useradd.

const CREATE_ACCOUNT_HELPER_URL = "http://127.0.0.1:7891/create-user";

const loginForm = document.getElementById("login-form");
const createForm = document.getElementById("create-account-form");
const loginMessage = document.getElementById("login-message");
const createMessage = document.getElementById("create-message");

document.getElementById("show-create-account").addEventListener("click", () => {
  loginForm.classList.add("hidden");
  createForm.classList.remove("hidden");
  createMessage.textContent = "";
});

document.getElementById("show-login").addEventListener("click", () => {
  createForm.classList.add("hidden");
  loginForm.classList.remove("hidden");
  loginMessage.textContent = "";
});

function prefillLogin(username) {
  document.getElementById("login-username").value = username;
  document.getElementById("login-password").value = "";
  document.getElementById("login-password").focus();
}

// --- Account creation -------------------------------------------------

createForm.addEventListener("submit", async (event) => {
  event.preventDefault();

  const username = document.getElementById("new-username").value.trim();
  const password = document.getElementById("new-password").value;
  const confirm = document.getElementById("new-password-confirm").value;

  if (!/^[a-z_][a-z0-9_-]{0,31}$/.test(username)) {
    createMessage.textContent = "Username must be lowercase, start with a letter or underscore.";
    return;
  }
  if (password.length < 8) {
    createMessage.textContent = "Password must be at least 8 characters.";
    return;
  }
  if (password !== confirm) {
    createMessage.textContent = "Passwords do not match.";
    return;
  }

  createMessage.textContent = "Creating account...";

  try {
    const response = await fetch(CREATE_ACCOUNT_HELPER_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username, password }),
    });
    const result = await response.json();

    if (response.ok && result.ok) {
      createForm.classList.add("hidden");
      loginForm.classList.remove("hidden");
      prefillLogin(username);
      loginMessage.textContent = "Account created. Sign in with your new password.";
    } else {
      createMessage.textContent = result.error || "Could not create account.";
    }
  } catch (err) {
    createMessage.textContent = "Could not reach account-creation helper.";
  }
});

// --- Sign in, via the greeter bridge -----------------------------------

if (window.lightdm) {
  let pendingResponse = null;

  window.lightdm.show_prompt = (text, type) => {
    if (pendingResponse !== null) {
      window.lightdm.respond(pendingResponse);
      pendingResponse = null;
    }
  };

  window.lightdm.show_message = (text) => {
    loginMessage.textContent = text;
  };

  window.lightdm.authentication_complete = () => {
    if (window.lightdm.is_authenticated) {
      const session = (window.lightdm.default_session || {}).key;
      window.lightdm.start_session(session);
    } else {
      loginMessage.textContent = "Sign-in failed.";
    }
  };

  loginForm.addEventListener("submit", (event) => {
    event.preventDefault();
    const username = document.getElementById("login-username").value.trim();
    pendingResponse = document.getElementById("login-password").value;
    loginMessage.textContent = "Signing in...";
    window.lightdm.authenticate(username);
  });
} else {
  loginMessage.textContent = "Greeter bridge not available (theme preview outside web-greeter?)";
}

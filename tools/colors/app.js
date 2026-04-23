const MANIFEST_PATH = "./data/schemes.manifest.json";
const EXPORT_VERSION_KEY = "filo-colors-export-version";

const state = {
  schemes: [],
  originalSchemes: [],
  selectedSchemeId: null,
  editMode: false,
  exportVersion: loadExportVersion(),
  dirty: false,
  openPickerId: null,
  pendingExport: null,
};

const elements = {
  schemeList: document.querySelector("#scheme-list"),
  schemeTitle: document.querySelector("#scheme-title"),
  lightTable: document.querySelector("#light-table"),
  darkTable: document.querySelector("#dark-table"),
  actionBar: document.querySelector("#action-bar"),
  editModeToggle: document.querySelector("#edit-mode-toggle"),
  resetButton: document.querySelector("#reset-button"),
  applyButton: document.querySelector("#apply-button"),
  generateButton: document.querySelector("#generate-button"),
  generateDialog: document.querySelector("#generate-dialog"),
  generateDialogFilename: document.querySelector("#generate-dialog-filename"),
  generateDialogLink: document.querySelector("#generate-dialog-link"),
  generateDialogStatus: document.querySelector("#generate-dialog-status"),
  generateCancel: document.querySelector("#generate-cancel"),
  generateConfirm: document.querySelector("#generate-confirm"),
  tokenRowTemplate: document.querySelector("#token-row-template"),
};

boot().catch((error) => {
  console.error(error);
  elements.schemeTitle.textContent = "Failed to load";
});

async function boot() {
  wireEvents();
  const manifest = await fetchJson(MANIFEST_PATH);
  const schemeFiles = manifest.schemeFiles || [];
  const rawSchemes = await Promise.all(schemeFiles.map((file) => fetchJson(`./data/${file}`)));
  state.schemes = rawSchemes.map(normalizeScheme);
  state.originalSchemes = structuredClone(state.schemes);
  state.selectedSchemeId = state.schemes[0]?.id ?? null;
  render();
}

function wireEvents() {
  elements.editModeToggle.addEventListener("change", (event) => {
    state.editMode = event.target.checked;
    if (!state.editMode) {
      state.openPickerId = null;
    }
    renderTables();
    syncActionState();
  });

  elements.resetButton.addEventListener("click", () => {
    state.schemes = structuredClone(state.originalSchemes);
    state.dirty = false;
    state.openPickerId = null;
    render();
  });

  elements.applyButton.addEventListener("click", () => {
    if (!state.dirty) return;
    state.originalSchemes = structuredClone(state.schemes);
    state.dirty = false;
    syncActionState();
  });

  elements.generateButton.addEventListener("click", () => {
    const selectedScheme = getSelectedScheme();
    if (!selectedScheme) return;
    const nextVersion = bumpPatchVersion(state.exportVersion);
    const filename = `${slugify(selectedScheme.name)}-v${nextVersion}.json`;
    state.pendingExport = { version: nextVersion, filename, schemeId: selectedScheme.id };
    elements.generateDialogFilename.textContent = filename;
    resetExportFeedback();
    elements.generateDialogStatus.hidden = true;
    elements.generateDialogStatus.textContent = "";
    elements.generateDialog.showModal();
  });

  elements.generateCancel.addEventListener("click", () => {
    state.pendingExport = null;
    resetExportFeedback();
    elements.generateDialog.close();
  });

  elements.generateConfirm.addEventListener("click", async () => {
    if (!state.pendingExport) return;

    const { version, filename, schemeId } = state.pendingExport;
    const scheme = state.schemes.find((item) => item.id === schemeId);
    if (!scheme) return;
    const payload = buildExportScheme(scheme, version);

    try {
      const result = await saveJsonFile(payload, filename);
      state.exportVersion = version;
      localStorage.setItem(EXPORT_VERSION_KEY, version);

      if (result.mode === "picker") {
        state.pendingExport = null;
        resetExportFeedback();
        elements.generateDialog.close();
        return;
      }

      elements.generateDialogLink.hidden = false;
      elements.generateDialogLink.href = result.url;
      elements.generateDialogLink.download = filename;
      elements.generateDialogLink.dataset.objectUrl = result.url;
      elements.generateDialogStatus.hidden = false;
      elements.generateDialogStatus.textContent = "If the download did not start, use the manual link above.";
      state.pendingExport = null;
    } catch (error) {
      if (error?.name === "AbortError") {
        return;
      }

      console.error(error);
      elements.generateDialogStatus.hidden = false;
      elements.generateDialogStatus.textContent = "Save failed. Use the manual download link if it appears, or try again.";
    }
  });

}

function resetExportFeedback() {
  if (elements.generateDialogLink.dataset.objectUrl) {
    URL.revokeObjectURL(elements.generateDialogLink.dataset.objectUrl);
  }
  elements.generateDialogLink.hidden = true;
  elements.generateDialogLink.href = "#";
  elements.generateDialogLink.removeAttribute("download");
  delete elements.generateDialogLink.dataset.objectUrl;
  elements.generateDialogStatus.hidden = true;
  elements.generateDialogStatus.textContent = "";
}

function render() {
  renderSchemeList();
  renderTitle();
  renderTables();
  syncActionState();
}

function renderSchemeList() {
  elements.schemeList.innerHTML = "";

  for (const scheme of state.schemes) {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "scheme-tab";
    button.dataset.active = String(scheme.id === state.selectedSchemeId);
    button.innerHTML = `
      <span class="scheme-tab-name">${escapeHtml(scheme.name)}</span>
    `;
    button.addEventListener("click", () => {
      state.selectedSchemeId = scheme.id;
      render();
    });
    elements.schemeList.append(button);
  }
}

function renderTitle() {
  const scheme = getSelectedScheme();
  if (!scheme) return;

  elements.schemeTitle.textContent = scheme.name;
}

function renderTables() {
  const scheme = getSelectedScheme();
  if (!scheme) return;

  renderTokenTable(elements.lightTable, scheme, "light");
  renderTokenTable(elements.darkTable, scheme, "dark");
}

function renderTokenTable(container, scheme, mode) {
  container.innerHTML = "";

  for (const token of scheme.tokens) {
    const row = elements.tokenRowTemplate.content.firstElementChild.cloneNode(true);
    const value = token[mode];
    const color = parseColor(value);
    const pickerState = colorToPickerState(color);
    const pickerId = getPickerId(scheme.id, token.key, mode);

    row.querySelector(".token-key").textContent = token.key;

    const swatch = row.querySelector(".token-swatch");
    const picker = row.querySelector(".token-picker");
    const sv = row.querySelector(".token-picker-sv");
    const svHandle = row.querySelector(".token-picker-sv-handle");
    const hue = row.querySelector(".token-picker-hue");
    const hueHandle = row.querySelector(".token-picker-hue-handle");
    const alphaWrap = row.querySelector(".token-alpha");
    const alphaSlider = row.querySelector(".token-alpha-slider");
    const alphaValue = row.querySelector(".token-alpha-value");
    const hexElement = row.querySelector(".token-hex");
    const rgbElement = row.querySelector(".token-rgb");

    syncRowColor({
      row,
      color,
      pickerState,
      swatch,
      sv,
      svHandle,
      hueHandle,
      alphaSlider,
      alphaValue,
      hexElement,
      rgbElement,
    });

    swatch.dataset.editable = String(state.editMode);
    picker.hidden = !(state.editMode && state.openPickerId === pickerId);

    const hasAlpha = color.alpha < 1;
    alphaWrap.dataset.visible = String(state.editMode && hasAlpha);

    swatch.addEventListener("click", () => {
      if (!state.editMode) return;
      state.openPickerId = state.openPickerId === pickerId ? null : pickerId;
      renderTables();
    });

    bindDrag(sv, (clientX, clientY) => {
      const rect = sv.getBoundingClientRect();
      const saturation = clamp((clientX - rect.left) / rect.width, 0, 1);
      const valueLevel = 1 - clamp((clientY - rect.top) / rect.height, 0, 1);
      pickerState.s = saturation;
      pickerState.v = valueLevel;
      const next = pickerStateToCssColor(pickerState, color.alpha);
      const nextColor = parseColor(next);
      setTokenColor(scheme.id, token.key, mode, next);
      syncRowColor({
        row,
        color: nextColor,
        pickerState,
        swatch,
        sv,
        svHandle,
        hueHandle,
        alphaSlider,
        alphaValue,
        hexElement,
        rgbElement,
      });
    });

    bindDrag(hue, (clientX) => {
      const rect = hue.getBoundingClientRect();
      const ratio = clamp((clientX - rect.left) / rect.width, 0, 1);
      pickerState.h = ratio * 360;
      const next = pickerStateToCssColor(pickerState, color.alpha);
      const nextColor = parseColor(next);
      setTokenColor(scheme.id, token.key, mode, next);
      syncRowColor({
        row,
        color: nextColor,
        pickerState,
        swatch,
        sv,
        svHandle,
        hueHandle,
        alphaSlider,
        alphaValue,
        hexElement,
        rgbElement,
      });
    });

    alphaSlider.addEventListener("input", (event) => {
      const nextAlpha = Number(event.target.value) / 100;
      const next = pickerStateToCssColor(pickerState, nextAlpha);
      const nextColor = parseColor(next);
      setTokenColor(scheme.id, token.key, mode, next);
      syncRowColor({
        row,
        color: nextColor,
        pickerState,
        swatch,
        sv,
        svHandle,
        hueHandle,
        alphaSlider,
        alphaValue,
        hexElement,
        rgbElement,
      });
    });

    container.append(row);
  }
}

function setTokenColor(schemeId, tokenKey, mode, nextCssColor) {
  const scheme = state.schemes.find((item) => item.id === schemeId);
  const token = scheme?.tokens.find((item) => item.key === tokenKey);
  if (!token) return;

  token[mode] = nextCssColor;
  state.dirty = isDirty();
  syncActionState();
}

function getSelectedScheme() {
  return state.schemes.find((scheme) => scheme.id === state.selectedSchemeId) ?? null;
}

function normalizeScheme(rawScheme) {
  const colorSource = rawScheme.tokenReplacements?.color || rawScheme.color || {};
  const tokens = Object.entries(colorSource).map(([key, value]) => ({
    key,
    name: prettifyTokenName(key),
    usage: value.usage || "",
    light: value.light,
    dark: value.dark,
  }));

  return {
    id: slugify(rawScheme.name || "scheme"),
    name: rawScheme.name || "Untitled Scheme",
    version: rawScheme.version || "1.0.0",
    notes: rawScheme.notes || [],
    target: rawScheme.target || "Filo Desktop",
    purpose: rawScheme.purpose || "",
    semanticAliases: rawScheme.semanticAliases || defaultSemanticAliases(),
    applicationOrder: rawScheme.applicationOrder || [],
    raw: structuredClone(rawScheme),
    tokens,
  };
}

function buildExportScheme(scheme, version = state.exportVersion) {
  const color = {};
  for (const token of scheme.tokens) {
    color[token.key] = {
      light: token.light,
      dark: token.dark,
      usage: token.usage,
    };
  }

  const exportObject = structuredClone(scheme.raw);
  exportObject.name = scheme.name;
  exportObject.target = scheme.target;
  exportObject.version = version;
  exportObject.purpose = scheme.purpose || exportObject.purpose || "Generated by Filo Colors";
  exportObject.notes = Array.isArray(scheme.notes) ? scheme.notes : [];
  exportObject.applicationOrder = scheme.applicationOrder.length
    ? scheme.applicationOrder
    : exportObject.applicationOrder || [
        "Replace filo-design/tokens.json color values with tokenReplacements.color",
        "Replace filo-desktop/src/index.css light and dark --color1..--color25 values with desktopVariables.light and desktopVariables.dark",
        "Replace filo-desktop/src/lib/themed.ts values with desktopVariablesHex.light and desktopVariablesHex.dark",
      ];
  exportObject.semanticAliases = scheme.semanticAliases || exportObject.semanticAliases || defaultSemanticAliases();
  exportObject.tokenReplacements = { color };
  exportObject.desktopVariables = buildDesktopVariables(color);
  exportObject.desktopVariablesHex = buildDesktopHexVariables(color);

  return exportObject;
}

function buildDesktopVariables(color) {
  const light = {};
  const dark = {};

  for (const [tokenKey, tokenValue] of Object.entries(color)) {
    const number = tokenKey.split("-")[0].replace(/^0+/, "");
    const cssKey = `--color${number}`;
    light[cssKey] = desktopVariableValue(number, tokenValue.light);
    dark[cssKey] = desktopVariableValue(number, tokenValue.dark);
  }

  return { light, dark };
}

function buildDesktopHexVariables(color) {
  const light = {};
  const dark = {};

  for (const [tokenKey, tokenValue] of Object.entries(color)) {
    const number = tokenKey.split("-")[0].replace(/^0+/, "");
    const jsKey = `color${number}`;
    light[jsKey] = tokenValue.light;
    dark[jsKey] = tokenValue.dark;
  }

  return { light, dark };
}

function desktopVariableValue(number, value) {
  if (["2", "6", "7", "9", "10"].includes(number)) {
    return formatHslTriplet(parseColor(value));
  }
  return value;
}

function parseColor(value) {
  const normalized = String(value).trim();
  if (normalized.startsWith("#")) {
    return parseHexColor(normalized);
  }
  if (normalized.startsWith("rgba")) {
    return parseRgbColor(normalized);
  }
  if (normalized.startsWith("rgb")) {
    return parseRgbColor(normalized);
  }
  throw new Error(`Unsupported color format: ${value}`);
}

function parseHexColor(hex) {
  const raw = hex.replace("#", "");
  const expanded = raw.length === 3 || raw.length === 4
    ? raw.split("").map((char) => char + char).join("")
    : raw;

  const hasAlpha = expanded.length === 8;
  const r = Number.parseInt(expanded.slice(0, 2), 16);
  const g = Number.parseInt(expanded.slice(2, 4), 16);
  const b = Number.parseInt(expanded.slice(4, 6), 16);
  const alpha = hasAlpha ? Number.parseInt(expanded.slice(6, 8), 16) / 255 : 1;

  return buildColorObject(r, g, b, alpha);
}

function parseRgbColor(rgbString) {
  const matches = rgbString.match(/rgba?\(([^)]+)\)/i);
  if (!matches) throw new Error(`Invalid rgb color: ${rgbString}`);
  const parts = matches[1].split(",").map((part) => part.trim());
  const [r, g, b] = parts.slice(0, 3).map((part) => Number.parseFloat(part));
  const alpha = parts[3] === undefined ? 1 : Number.parseFloat(parts[3]);
  return buildColorObject(r, g, b, alpha);
}

function buildColorObject(r, g, b, alpha) {
  const clamp = (value, min, max) => Math.min(max, Math.max(min, value));
  const safeAlpha = clamp(alpha, 0, 1);
  const hex6 = `#${toHex(r)}${toHex(g)}${toHex(b)}`.toUpperCase();
  const hex8 = `#${toHex(r)}${toHex(g)}${toHex(b)}${toHex(Math.round(safeAlpha * 255))}`.toUpperCase();
  return {
    r,
    g,
    b,
    alpha: safeAlpha,
    hex6,
    hex8,
    css: safeAlpha < 1 ? `rgba(${r}, ${g}, ${b}, ${round(safeAlpha, 2)})` : hex6,
  };
}

function formatHex(color) {
  return color.alpha < 1 ? color.hex8 : color.hex6;
}

function formatRgb(color) {
  return color.alpha < 1
    ? `rgba(${color.r}, ${color.g}, ${color.b}, ${round(color.alpha, 2)})`
    : `rgb(${color.r}, ${color.g}, ${color.b})`;
}

function formatHslTriplet(color) {
  const { h, s, l } = rgbToHsl(color.r, color.g, color.b);
  return `${Math.round(h)} ${Math.round(s)}% ${Math.round(l)}%`;
}

function rgbToHsl(r, g, b) {
  const red = r / 255;
  const green = g / 255;
  const blue = b / 255;
  const max = Math.max(red, green, blue);
  const min = Math.min(red, green, blue);
  const delta = max - min;
  let h = 0;
  const l = (max + min) / 2;
  const s = delta === 0 ? 0 : delta / (1 - Math.abs(2 * l - 1));

  if (delta !== 0) {
    if (max === red) {
      h = 60 * (((green - blue) / delta) % 6);
    } else if (max === green) {
      h = 60 * ((blue - red) / delta + 2);
    } else {
      h = 60 * ((red - green) / delta + 4);
    }
  }

  if (h < 0) h += 360;
  return { h, s: s * 100, l: l * 100 };
}

function rgbToHsv(r, g, b) {
  const red = r / 255;
  const green = g / 255;
  const blue = b / 255;
  const max = Math.max(red, green, blue);
  const min = Math.min(red, green, blue);
  const delta = max - min;
  let h = 0;

  if (delta !== 0) {
    if (max === red) {
      h = 60 * (((green - blue) / delta) % 6);
    } else if (max === green) {
      h = 60 * ((blue - red) / delta + 2);
    } else {
      h = 60 * ((red - green) / delta + 4);
    }
  }

  if (h < 0) h += 360;

  return {
    h,
    s: max === 0 ? 0 : delta / max,
    v: max,
  };
}

function hsvToRgb(h, s, v) {
  const hue = ((h % 360) + 360) % 360;
  const chroma = v * s;
  const x = chroma * (1 - Math.abs(((hue / 60) % 2) - 1));
  const m = v - chroma;
  let r1 = 0;
  let g1 = 0;
  let b1 = 0;

  if (hue < 60) {
    r1 = chroma; g1 = x;
  } else if (hue < 120) {
    r1 = x; g1 = chroma;
  } else if (hue < 180) {
    g1 = chroma; b1 = x;
  } else if (hue < 240) {
    g1 = x; b1 = chroma;
  } else if (hue < 300) {
    r1 = x; b1 = chroma;
  } else {
    r1 = chroma; b1 = x;
  }

  return {
    r: Math.round((r1 + m) * 255),
    g: Math.round((g1 + m) * 255),
    b: Math.round((b1 + m) * 255),
  };
}

function colorToPickerState(color) {
  const { h, s, v } = rgbToHsv(color.r, color.g, color.b);
  return { h, s, v };
}

function pickerStateToCssColor(pickerState, alpha = 1) {
  const { r, g, b } = hsvToRgb(pickerState.h, pickerState.s, pickerState.v);
  return alpha < 1 ? `rgba(${r}, ${g}, ${b}, ${round(alpha, 2)})` : buildColorObject(r, g, b, 1).hex6;
}

function syncRowColor({
  color,
  pickerState,
  swatch,
  sv,
  svHandle,
  hueHandle,
  alphaSlider,
  alphaValue,
  hexElement,
  rgbElement,
}) {
  swatch.style.setProperty("--swatch-color", color.css);
  sv.style.setProperty("--picker-hue", `hsl(${pickerState.h} 100% 50%)`);
  svHandle.style.left = `${pickerState.s * 100}%`;
  svHandle.style.top = `${(1 - pickerState.v) * 100}%`;
  hueHandle.style.left = `${(pickerState.h / 360) * 100}%`;
  alphaSlider.value = String(Math.round(color.alpha * 100));
  alphaValue.textContent = `${Math.round(color.alpha * 100)}%`;
  hexElement.textContent = formatHex(color);
  rgbElement.textContent = formatRgb(color);
}

function bindDrag(element, onMove) {
  const handlePointer = (event) => {
    event.preventDefault();
    onMove(event.clientX, event.clientY);
  };

  element.addEventListener("pointerdown", (event) => {
    handlePointer(event);
    const move = (moveEvent) => handlePointer(moveEvent);
    const up = () => {
      window.removeEventListener("pointermove", move);
      window.removeEventListener("pointerup", up);
    };
    window.addEventListener("pointermove", move);
    window.addEventListener("pointerup", up);
  });
}

function getPickerId(schemeId, tokenKey, mode) {
  return `${schemeId}:${tokenKey}:${mode}`;
}

function defaultSemanticAliases() {
  return {
    filoPrimary: "02-primary",
    filoSecondary: "01-primary-light",
    background: "10-background",
    surface: "09-surface-tertiary",
    textPrimary: "06-text-primary",
    textSecondary: "07-text-secondary",
    textTertiary: "08-text-tertiary",
    error: "11-error",
    warning: "12-important",
    success: "18-success",
    info: "13-info",
    overlay: "14-overlay-light",
  };
}

function loadExportVersion() {
  return localStorage.getItem(EXPORT_VERSION_KEY) || "1.0.0";
}

function isDirty() {
  return JSON.stringify(state.schemes) !== JSON.stringify(state.originalSchemes);
}

function syncActionState() {
  elements.actionBar.dataset.editMode = String(state.editMode);
  elements.applyButton.disabled = !state.dirty;
}

function bumpPatchVersion(version) {
  const parts = version.split(".").map((part) => Number.parseInt(part, 10));
  while (parts.length < 3) parts.push(0);
  parts[2] += 1;
  return parts.join(".");
}

async function fetchJson(path) {
  const response = await fetch(path);
  if (!response.ok) {
    throw new Error(`Failed to load ${path}`);
  }
  return response.json();
}

function downloadJson(payload, filename) {
  const blob = new Blob([JSON.stringify(payload, null, 2)], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement("a");
  anchor.href = url;
  anchor.download = filename;
  anchor.target = "_blank";
  anchor.rel = "noopener";
  document.body.append(anchor);
  anchor.click();
  anchor.remove();
  setTimeout(() => URL.revokeObjectURL(url), 60_000);
  return url;
}

async function saveJsonFile(payload, filename) {
  const contents = JSON.stringify(payload, null, 2);

  if (typeof window.showSaveFilePicker === "function") {
    const handle = await window.showSaveFilePicker({
      suggestedName: filename,
      types: [
        {
          description: "JSON files",
          accept: {
            "application/json": [".json"],
          },
        },
      ],
    });
    const writable = await handle.createWritable();
    await writable.write(contents);
    await writable.close();
    return { mode: "picker" };
  }

  return { mode: "download", url: downloadJson(payload, filename) };
}

function slugify(value) {
  return value.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, "");
}

function prettifyTokenName(key) {
  return key
    .replace(/^\d{2}-/, "")
    .split("-")
    .map((part) => capitalize(part))
    .join(" ");
}

function capitalize(value) {
  return value.charAt(0).toUpperCase() + value.slice(1);
}

function toHex(value) {
  return Math.round(value).toString(16).padStart(2, "0");
}

function round(value, digits = 2) {
  const factor = 10 ** digits;
  return Math.round(value * factor) / factor;
}

function clamp(value, min, max) {
  return Math.min(max, Math.max(min, value));
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

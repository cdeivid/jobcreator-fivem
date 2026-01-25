-- Placeholder locales for additional languages
-- These should be translated by the community

-- Crear tabla Locales si no está definida
Locales = Locales or {}

-- Idioma en inglés base
Locales['en'] = Locales['en'] or {}

-- Greek - Placeholder (needs translation)
Locales['el'] = {}
if Locales['en'] ~= nil then
    for k, v in pairs(Locales['en']) do
        Locales['el'][k] = v .. ' [EL]'
    end
else
    print("Error: Locales['en'] no está definido.")
end

-- Bosnian - Placeholder (needs translation)
Locales['bs'] = {}
if Locales['en'] ~= nil then
    for k, v in pairs(Locales['en']) do
        Locales['bs'][k] = v .. ' [BS]'
    end
else
    print("Error: Locales['en'] no está definido.")
end

-- Slovak - Placeholder (needs translation)
Locales['sk'] = {}
if Locales['en'] ~= nil then
    for k, v in pairs(Locales['en']) do
        Locales['sk'][k] = v .. ' [SK]'
    end
else
    print("Error: Locales['en'] no está definido.")
end

-- Danish - Placeholder (needs translation)
Locales['da'] = {}
if Locales['en'] ~= nil then
    for k, v in pairs(Locales['en']) do
        Locales['da'][k] = v .. ' [DA]'
    end
else
    print("Error: Locales['en'] no está definido.")
end

-- Czech - Placeholder (needs translation)
Locales['cs'] = {}
if Locales['en'] ~= nil then
    for k, v in pairs(Locales['en']) do
        Locales['cs'][k] = v .. ' [CS]'
    end
else
    print("Error: Locales['en'] no está definido.")
end

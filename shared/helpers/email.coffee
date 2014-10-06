ns = Util.email = {}


###
Retrieves the domain name from an email address
@param email: The email address to extract the domain from
###
ns.domainFromEmail = (email) ->
  return null unless email
  trimmedDomain = email.split('@')?[1]?.trim().toLowerCase()
  if trimmedDomain?.lastIndexOf('>') > -1
    return null
  return trimmedDomain

###
Retrieves the name from the email address
i.e. will retrieve Phil Cockfield from 'Phil Cockfield <phil@cockfield.net>'
@param email
###
ns.getNameFromEmail = (email) ->
  return null unless email

  email = email.trim()

  # If the email ends with > then strip to the name before <
  lastClose = email.lastIndexOf('>')
  if lastClose == email.length - 1 && lastClose >= 0
    lastOpen = email.lastIndexOf('<')
    # If there's something before the < in <email.example.com>
    if lastOpen > 0
      name = email.slice(0, lastOpen).trim()

      # If the first and last are ' or " then strip them.
      if name.slice(0,1) == "'" || name.slice(0,1) == '"'
        length = name.length
        if name.slice(length - 1) == "'" || name.slice(length - 1) == '"'
          name = name.slice(1, length - 1)

      return name

  # If there was no <> or nothing before the last <, return the string before the first @
  return ns.cleanEmail(email)?.split('@')[0]




###
Clean Email - trims whitespace, converts the domain name to lowercase,
    and extracts the email from between <> if they're present
@param email
###
ns.cleanEmail = (email) ->
  return null unless email

  email = email.trim()
  unless email.indexOf('@') > -1
    console.log "No email found in string passed to cleanEmail: #{email}".red
    return null

  # If the email ends with <> then strip to the email address between them
  lastClose = email.lastIndexOf('>')
  if lastClose == email.length - 1 && lastClose >= 0
    lastOpen = email.lastIndexOf('<')
    if lastOpen >= 0
      email = email.slice(lastOpen + 1, lastClose)

  emailParts = email.trim().split('@')

  # Lowercase the domain which is in the last part
  emailParts[emailParts.length - 1] = emailParts[emailParts.length - 1].toLowerCase()

  # Join all the parts with @ and return it
  emailParts.join('@')


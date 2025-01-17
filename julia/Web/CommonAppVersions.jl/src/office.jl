# Office 2013
const OFFICE_2013_URI = "https://docs.microsoft.com/en-us/officeupdates/update-history-office-2013"

# Office 2016
const OFFICE_2016_RETAIL_URI = "https://docs.microsoft.com/en-gb/officeupdates/update-history-office-2019"
const OFFICE_2016_RETAIL_REGEX = r"Version (?:\d+) \(Build (\d+).(?:\d+)\)"
const OFFICE_2016_MSI_URI = "https://docs.microsoft.com/en-us/officeupdates/office-updates-msi"
# const OFFICE_365_GUID = "4b323baf-6213-40ab-81b2-aa37d83f7296"
const OFFICE_SUPPORT_BASE_URI = "https://support.microsoft.com/"

# Office 365
const OFFICE_365_BUILD_URI = "https://docs.microsoft.com/en-us/officeupdates/update-history-microsoft365-apps-by-date/"
const OFFICE_365_NOGUID_URI = "https://support.microsoft.com/en-us/office/what-s-new-in-microsoft-365"
const OFFICE_365_GUID = "95c8d81d-08ba-42c1-914f-bca4603e1426"
const OFFICE_365_URI = OFFICE_365_NOGUID_URI * "-" * OFFICE_365_GUID
const OFFICE_365_VERSION_ID_REGEX = r"version-(?:\d+)-(?:january|february|march|april|may|june|july|august|september|october|november|december)-(?:\d{1,3})"
const OFFICE_365_VERSION_REGEX = r"Version (?:\d+) \(Build (\d+\.\d+)\)"

# Types/structs

abstract type MicrosoftOfficeSingleton <: CommonApplication end

struct Office2007Singleton <: MicrosoftOfficeSingleton end
const Office2007 = Office2007Singleton()

struct Office2010Singleton <: MicrosoftOfficeSingleton end
const Office2010 = Office2010Singleton()

struct Office2013Singleton <: MicrosoftOfficeSingleton end
const Office2013 = Office2013Singleton()

struct Office2016Singleton <: MicrosoftOfficeSingleton end
const Office2016 = Office2016Singleton()

struct Office365Singleton <: MicrosoftOfficeSingleton end
const Office365 = Office365Singleton()

# Version methods

get_latest_version(::Office2007Singleton) = VersionNumber("12.0.6612")  # EOL: 10 Oct., 2017

get_latest_version(::Office2010Singleton) = VersionNumber("14.0.7261")  # EOL: 13 Oct., 2020

function _get_latest_version(::Office2013Singleton, ::WindowsOperatingSystem)
    # NOTE: Using the Knowledge Base URL code from `_get_latest_version(::Office2016Singleton, ::WindowsOperatingSystem)`
    # we could look for `"Microsoft Office 2013"` instead of `"Microsoft Office 2016"` and then follow the same method.
    # But as there is this decidedly simpler method to obtain the version for this, we could stick with that here.
    # Just something to think about in the future
    r = HTTP.get(OFFICE_2013_URI)
    doc = Gumbo.parsehtml(String(r.body))
    elem = _findfirst_html_tag(doc.root, "id" => "center-doc-outline", tag = :nav)
    next_elem = _nextsibling(elem, 3) # go to the 3rd next element
    note_elem = _findfirst_html_text(next_elem, :p, "The most current version of Office 2013 is", exact = false)
    v_str = onlychild(note_elem.children[2]).text # e.g., `<p>The most current version of Office 2013 is <strong>15.0.5423.1000</strong>, which was released on February 8, 2022.</p>`
    return vparse(v_str)
end

function _get_latest_retail_version(::Office2016Singleton, ::WindowsOperatingSystem)
    # Retail version - build major version is the micro version for Office 2016
    # Source: https://github.com/MicrosoftDocs/OfficeDocs-OfficeUpdates/issues/49#issuecomment-423573620
    # My plea: https://github.com/MicrosoftDocs/OfficeDocs-OfficeUpdates/issues/302#issuecomment-1044330345
    r = HTTP.get(OFFICE_2016_RETAIL_URI)
    doc = Gumbo.parsehtml(String(r.body))
    elem = _findfirst_html_tag(doc.root, "id" => "retail-versions-of-office-2016-c2r-and-office-2019", tag = :h2)
    versions = _nextsibling(elem, 2).children[2].children # go to the 2nd next element
    unmatched_build_str = onlychild(versions[1].children[2]).text
    m = match(OFFICE_2016_RETAIL_REGEX, unmatched_build_str)
    build_str = only(m.captures)
    return vparse("16.0." * build_str)
end

function _get_latest_version(::Office2016Singleton, ::WindowsOperatingSystem)
    # MSI version
    # NOTE: it is possible that Office 2016 is now using the same version as Office 365

    # Follow the link in the `Latest Public Update (PU)` column for most recent updates
    r1 = HTTP.get(OFFICE_2016_MSI_URI)
    doc1 = Gumbo.parsehtml(String(r1.body))
    elem1 = _findfirst_html_tag(doc1.root, "id" => "office-2016-updates", tag = :h2)
    # Note that as of April 2024, below this heading there is an alert (class="IMPORTANT")
    # containing information about end of life for Office 2016.  This is why we skip to the
    # next _next_ element.
    next_elem1 = _nextsibling(elem1, 2)
    up_uri = _findfirst_html_text(next_elem1, :a, r"KB(\d+)", exact = false).attributes["href"]

    # Find the most recently updated app, ang go to its Knowledge Base URL
    r2 = HTTP.get(up_uri)
    doc2 = Gumbo.parsehtml(String(r2.body))
    elem2 = _findfirst_html_text(doc2.root, :h3, "Microsoft Office 2016")
    next_elem2 = _nextsibling(elem2)
    kb_uri = _findfirst_html_tag(next_elem2, "class" => "ocpArticleLink", tag = :a).attributes["href"]

    # Get the top-most element in the supported x64-based versions
    # We iterate over the table of files that have been changed and take the largest version,
    # hoping that the largest version does indeed correspond to the latest version of
    # Office 2016 (it seems to, so far!).  The other thing to do would be to just take the
    # top-most row in the table, as the table is sorted by date, but I don't quite trust
    # that the top row will pertain to the latest version.
    r3 = HTTP.get(OFFICE_SUPPORT_BASE_URI * kb_uri)
    doc3 = Gumbo.parsehtml(String(r3.body))

    ## 0. Common element required for next (changeable) step
    elem3 = _findfirst_html_tag(doc3.root, "aria-label" => "File information", tag = :section)

    ## 1. Original find version table code
    # elem4 = _findfirst_html_tag(elem3, "aria-label" => "For all supported x64-based versions of"; exact = false, tag = :section)
    # tbl = _findfirst_html_tag(elem4, "class" => "banded", tag = :table).children[2].children # skip the table head

    ## 2. Fix for finding version table for March, May, and December, 2022
    # elem4 = _findfirst_html_class_text(elem3, "class" => "ocpLegacyBold", "x64"; exact = true, tag = :b)
    # tbl = _nextsibling(elem4.parent, 1).children[1].children[2].children[1].children[1].children[2].children # ignore table header

    ## 3. Fix for finding version table for April, 2022
    # elem4 = _findfirst_html_tag(elem3, "ocpExpandoHeadTitleContainer" => "For all supported x64-based versions of"; exact = false, tag = :div)
    # elem4 = _findfirst_html_class_text(elem3, "class" => "ocpExpandoHeadTitleContainer", "For all supported x64-based versions of"; exact = false, tag = :div)
    # tbl = _findfirst_html_tag(elem4.parent.parent.parent, "class" => "banded", tag = :table).children[2].children # skip the table header

    ## 4. Fix for finding version table for January--February, 2023
    # elem3 = _findfirst_html_text(doc3.root, :h3, "File information", exact = true)
    ### 4.a Jan, 2023
    # elem4 = _findfirst_html_tag(elem3.parent, "class" => "ocpExpandoBody")
    # tbl = onlychild(elem4).children[2].children # skip the table header
    ### 4.b Feb, 2023
    # elem4 = elem3.parent.children[3].children[2] |> onlychild |> onlychild
    # tbl = elem4.children[2].children  # skip the table header

    ## 5. Fix for finding version table for January, late March, and August, 2024
    # elem3 = _findfirst_html_text(doc3.root, "File information", tag = :h3)  # prefer to use ID (below) but can use this if ID changes
    # elem3 = _findfirst_html_tag(doc3.root, "id" => "ID0EDF", tag = :h2)
    ### 5.a. Get x64 arch element for Jan and March, 2024
    # elem4 = _findfirst_html_class_text(elem3.parent, "class" => "ocpLegacyBold", "x64"; exact = true, tag = :b)  # once we find the section heading, we need to go to the section in which the heading is contained, as this is where the header siblings are that we need to parse
    ### 5.b. Get x64 arch element for August 2024
    # elem4 = _findfirst_html_class_text(elem3.parent, "class" => "ocpLegacyBold", "x64"; exact = false, tag = :b)
    # elem5 = (_nextsibling(elem4.parent, 1) |> onlychild).children[2]  # get inner table for x64 (different architectures)
    # tbl = (elem5 |> onlychild |> onlychild).children[2].children  # ignore table header
    ### 5.c. Get x65 arch element for November, 2024, and January, 2025
    elem3 = _findfirst_html_tag(doc3.root, "id" => "ID0EFBBF", tag = :h3)
    #### 5.c.i Update for late November, 2024
    # elem3 = _findfirst_html_tag(doc3.root, "id" => "ID0EFBBH", tag = :h3)
    elem4 = _findfirst_html_class_text(elem3.parent, "class" => "ocpExpandoHeadTitleContainer", "x64"; exact = false, tag = :div)
    elem5 = _nextsibling(elem4.parent.parent, 1) |> onlychild |> onlychild  # get inner table for x64 (different architectures)
    tbl = elem5.children[2].children  # ignore table header


    ## 6. Fix for finding version table for early March and June, 2024
    # elem3 = _findfirst_html_text(doc3.root, :h3, "File information")
    # elem4 = _findfirst_html_class_text(elem3.parent, "class" => "ocpExpandoHeadTitleContainer", "x64"; exact = false, tag = :div)  # once we find the section heading, we need to go to the section in which the heading is contained, as this is where the header siblings are that we need to parse
    # elem5 = _nextsibling(elem4.parent.parent, 1)
    # elem6  = _findfirst_html_tag(elem5, "class" => "ocpExpandoBody", exact = true, tag = :div) |> onlychild
    # tbl = elem6.children[2].children  # ignore table header

    ## Get maximum version from table
    # v_str = tbl[1].children[3].children[1].children[1].text
    # return vparse(v_str)
    v_min = VersionNumber("0.0.0")
    return maximum(tbl) do tr
        # Specify the table index of the version number
        # i = 3
        # Update for June, 2024
        i = 2
        v_elem_container = onlychild(tr.children[i])

        ## 6.a. Original
        # v_elem = v_elem_container.children # the third column is the version number
        # v = isempty(v_elem) ? v_min : vparse(v_elem[1].text)

        ## 6.b. Fix for February, 2023
        # v = v_min
        # if !isempty(v_elem_container) && !isempty(v_elem_container.children)
            # v_elem = v_elem_container |> onlychild |> onlychild
            # v = vparse(v_elem.text)
        # end

        ## 6.c. Fix for January 2024
        # v_elem = v_elem_container.children

        ## 6.d. Fix for June, 2024 and November, 2024
        v_elem = onlychild(onlychild(v_elem_container))
        ### 6.d.i Fix for August, 2024
        # v_elem = onlychild(v_elem_container)
        v_str = v_elem.text
        v = try vparse(v_str) catch; v_min end  # to catch errors when the version is not a valid version number

        v
    end
end

function _get_latest_build_version(::Office365Singleton, ::WindowsOperatingSystem)
    r = HTTP.get(OFFICE_365_BUILD_URI)
    doc = Gumbo.parsehtml(String(r.body))
    elem = _findfirst_html_tag(doc.root, "id" => "supported-versions", tag = :h3)
    tbl = _nextsibling(elem)
    tbody = tbl.children[2]
    v_str = tbody.children[1].children[3].children[1].text # the third column is the version number
    return vparse(v_str)
end

function _get_latest_version(::Office365Singleton, ::WindowsOperatingSystem)
    @warn("Consider using _get_latest_retail_version(::Office2016Singleton, ::WindowsOperatingSystem) instead of _get_latest_version(::Office365Singleton, ::WindowsOperatingSystem), as this seems to be the correct version")

    r = HTTP.get(OFFICE_365_URI)
    doc = Gumbo.parsehtml(String(r.body))

    # Old (Office 365 GUID link
    #=elem = _findfirst_html_tag(doc.root, "id" => "Platform-supTabControlContent-2", tag = :div)
    # elem = _findfirst_html_tag(doc.root, "id" => "Platform-supTabControlContent-2", tag = :div)  # macOS version
    v_str = onlychild(elem.children[1].children[1].children[1].children[2].children[2]).text
    =#

    # Update for December, 2022
    elem = _findfirst_html_tag(doc.root, "id" => OFFICE_365_VERSION_ID_REGEX, tag = :h2, exact = false)
    v_info = onlychild(onlychild(_nextsibling(elem, 1))).text
    m = match(OFFICE_365_VERSION_REGEX, v_info)
    v_str = only(m.captures)

    return vparse(v_str)
end

function _get_latest_version(::Office365Singleton, ::MacOSOperatingSystem)
    error("not yet implemented")
end

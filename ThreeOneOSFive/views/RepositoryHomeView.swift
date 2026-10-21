import SwiftUI

/// A RoV-focused landing page inspired by the supplied video.
/// This is a UI dashboard only; it does not modify or inject into the game.
struct ROVDashboardView: View {
    @Environment(\.appLanguage) private var language
    @EnvironmentObject private var appState: AppState
    @AppStorage("rov.dashboard.showDevice") private var showDeviceCard = true
    @AppStorage("rov.dashboard.showCompatibility") private var showCompatibility = true
    @State private var showRoVDetails = false

    let onOpenSettings: () -> Void
    let onOpenLogs: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    brandHeader

                    if showDeviceCard {
                        deviceCard
                    }

                    Text(language.text("rov.game_library"))
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.primary)
                        .padding(.top, 2)

                    Button {
                        showRoVDetails = true
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(LinearGradient(colors: [Color(red: 0.42, green: 0.20, blue: 0.78), Color(red: 0.20, green: 0.12, blue: 0.48)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                Image(systemName: "gamecontroller.fill")
                                    .font(.system(size: 27, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 58, height: 58)

                            VStack(alignment: .leading, spacing: 5) {
                                Text("RoV")
                                    .font(.headline.weight(.bold))
                                    .foregroundStyle(.primary)
                                Text(language.text("rov.selected_game"))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                HStack(spacing: 5) {
                                    Circle().fill(appState.isSupported ? Color.green : Color.orange).frame(width: 6, height: 6)
                                    Text(language.text(appState.isSupported ? "rov.device_supported" : "rov.check_device"))
                                        .font(.caption2.weight(.medium))
                                        .foregroundStyle(appState.isSupported ? Color.green : Color.orange)
                                }
                            }
                            Spacer(minLength: 4)
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(AppTheme.accent)
                        }
                        .padding(14)
                        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(AppTheme.accent.opacity(0.22), lineWidth: 1))
                    }
                    .buttonStyle(.plain)

                    if showCompatibility {
                        compatibilityCard
                    }
                }
                .frame(maxWidth: 620, alignment: .leading)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .background(
                LinearGradient(
                    colors: [Color(uiColor: .systemBackground), Color(red: 0.30, green: 0.18, blue: 0.48).opacity(0.12), Color(uiColor: .systemBackground)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).ignoresSafeArea()
            )
            .navigationTitle("3105")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                AppUtilityToolbar(language: language, onOpenSettings: onOpenSettings, onOpenLogs: onOpenLogs)
            }
            .sheet(isPresented: $showRoVDetails) {
                NavigationStack {
                    VStack(spacing: 16) {
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 42, weight: .medium))
                            .foregroundStyle(AppTheme.accent)
                            .padding(22)
                            .background(AppTheme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                        Text("RoV")
                            .font(.title2.weight(.bold))
                        Text(language.text("rov.details_message"))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button(language.text("rov.open_settings")) {
                            showRoVDetails = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { onOpenSettings() }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(AppTheme.accent)
                    }
                    .padding(28)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppTheme.pageBackground)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(language.text("common.done")) { showRoVDetails = false }
                        }
                    }
                }
            }
        }
    }

    private var brandHeader: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(LinearGradient(colors: [Color(red: 0.49, green: 0.27, blue: 0.83), Color(red: 0.23, green: 0.13, blue: 0.52)], startPoint: .topLeading, endPoint: .bottomTrailing))
                Image(systemName: "crown.fill")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 54, height: 54)
            VStack(alignment: .leading, spacing: 3) {
                Text("3105 · RoV")
                    .font(.title3.weight(.heavy))
                Text(language.text("rov.dashboard_subtitle"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: onOpenSettings) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 42, height: 42)
                    .background(Color(uiColor: .secondarySystemBackground), in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(language.text("settings.title"))
        }
        .padding(16)
        .background(Color(uiColor: .secondarySystemBackground).opacity(0.88), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(AppTheme.accent.opacity(0.18), lineWidth: 1))
    }

    private var deviceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(language.text("common.device"), systemImage: "iphone.gen3")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(language.text(appState.isSupported ? "rov.device_supported" : "rov.check_device"))
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(appState.isSupported ? Color.green : Color.orange)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background((appState.isSupported ? Color.green : Color.orange).opacity(0.12), in: Capsule())
            }
            Divider()
            infoRow(language.text("dashboard.hardware_model"), AppInfo.displayMachineName)
            infoRow(language.text("settings.ios_version"), "iOS \(AppInfo.osVersion) (\(AppInfo.osBuild))")
        }
        .padding(16)
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var compatibilityCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(language.text("rov.compatibility"), systemImage: "checkmark.shield.fill")
                .font(.subheadline.weight(.bold))
            HStack(spacing: 8) {
                Image(systemName: appState.isSupported ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                    .foregroundStyle(appState.isSupported ? Color.green : Color.orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text(language.text(appState.isSupported ? "settings.supported" : "settings.unsupported"))
                        .font(.subheadline.weight(.semibold))
                    Text(language.text("rov.compatibility_note"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
        .padding(16)
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Spacer(minLength: 8)
            Text(value).font(.caption.weight(.medium)).multilineTextAlignment(.trailing)
        }
    }
}

struct CleanNewView: View {
    @Environment(\.appLanguage) private var language
    let onOpenSettings: () -> Void
    let onOpenLogs: () -> Void

    var body: some View {
        NavigationStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
                .navigationTitle(language.text("tab.new"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    AppUtilityToolbar(language: language, onOpenSettings: onOpenSettings, onOpenLogs: onOpenLogs)
                }
        }
    }
}


struct RepositoryHomeView: View {
    @Environment(\.appLanguage) private var language
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @EnvironmentObject private var store: PackageRepositoryStore
    @State private var feed: [RepositoryPackageRecord] = []

    let onOpenSettings: () -> Void
    let onOpenLogs: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 28) {
                    if feed.isEmpty {
                        emptyContent
                    } else {
                        featuredFeed
                        recentPackages
                    }

                }
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, AppTheme.contentCardInset)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .refreshable {
                await store.refreshAllAndWait()
                rebuildFeed()
            }
            .navigationTitle("3105")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                AppUtilityToolbar(
                    language: language,
                    onOpenSettings: onOpenSettings,
                    onOpenLogs: onOpenLogs
                )
            }
            .navigationDestination(for: RepositoryPackageRecord.self) { record in
                RepositoryPackageDetailView(record: record)
            }
            .onAppear {
                store.refreshAllIfNeeded()
                if feed.isEmpty {
                    rebuildFeed()
                }
            }
            .onChange(of: store.packages) { _ in
                rebuildFeed()
            }
        }
    }

    private var emptyContent: some View {
        marketplaceEmpty(
            systemImage: store.sources.isEmpty
                ? "shippingbox.and.arrow.backward"
                : "shippingbox",
            titleKey: store.sources.isEmpty
                ? "repository.no_sources_title"
                : "repository.no_packages_title",
            messageKey: store.sources.isEmpty
                ? "repository.home_no_sources_message"
                : "repository.no_packages_message"
        )
    }

    private var featuredFeed: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("repository.for_you")

            GeometryReader { proxy in
                let cardWidth = featuredCardWidth(availableWidth: proxy.size.width)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: featuredCardSpacing) {
                        ForEach(Array(feed.prefix(featuredPackageCount))) { record in
                            NavigationLink(value: record) {
                                RepositoryFeaturedCard(
                                    record: record,
                                    width: cardWidth,
                                    height: featuredCardHeight
                                )
                            }
                            .buttonStyle(RepositoryCardButtonStyle())
                        }
                    }
                }
            }
            .frame(height: featuredCardHeight)
        }
    }

    @ViewBuilder
    private var recentPackages: some View {
        let remaining = Array(feed.dropFirst(featuredPackageCount))
        if !remaining.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                sectionHeader("repository.more_patches")

                VStack(spacing: 0) {
                    ForEach(
                        Array(remaining.enumerated()),
                        id: \.element.id
                    ) { index, record in
                        NavigationLink(value: record) {
                            HStack(spacing: 12) {
                                RepositoryPackageRow(record: record)
                                Spacer(minLength: 8)
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.tertiary)
                                    .accessibilityHidden(true)
                            }
                            .padding(.horizontal, AppTheme.contentCardPadding)
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(RepositoryCardButtonStyle())

                        if index < remaining.count - 1 {
                            Divider()
                                .padding(.leading, 68)
                        }
                    }
                }
                .background(
                    Color(uiColor: .systemBackground),
                    in: RoundedRectangle(
                        cornerRadius: AppTheme.contentCardCornerRadius,
                        style: .continuous
                    )
                )
                .overlay {
                    AppCardBorder()
                }
            }
        }
    }

    private func sectionHeader(_ key: String) -> some View {
        Text(language.text(key))
            .font(.title3.weight(.bold))
            .foregroundStyle(.primary)
            .textCase(nil)
    }

    private func marketplaceEmpty(
        systemImage: String,
        titleKey: String,
        messageKey: String
    ) -> some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: AppTheme.emptyIconSize, weight: .light))
                .foregroundStyle(AppTheme.accent)
            Text(language.text(titleKey))
                .font(.headline)
            Text(language.text(messageKey))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 48)
        .background(
            Color(uiColor: .systemBackground),
            in: RoundedRectangle(
                cornerRadius: AppTheme.contentCardCornerRadius,
                style: .continuous
            )
        )
        .overlay {
            AppCardBorder()
        }
    }

    private func rebuildFeed() {
        feed = PackageRepositoryFeedPolicy.home(store.packages)
    }

    private var featuredPackageCount: Int {
        min(feed.count, 3)
    }

    private var featuredCardSpacing: CGFloat { 10 }

    private var featuredCardHeight: CGFloat {
        if dynamicTypeSize.isAccessibilitySize {
            return 180
        }
        if dynamicTypeSize >= .xxLarge {
            return 140
        }
        return 112
    }

    private func featuredCardWidth(availableWidth: CGFloat) -> CGFloat {
        if dynamicTypeSize.isAccessibilitySize {
            return min(320, max(260, availableWidth * 0.82))
        }
        if dynamicTypeSize >= .xxLarge {
            return min(
                260,
                max(200, (availableWidth - featuredCardSpacing) / 1.45)
            )
        }
        return min(
            240,
            max(140, (availableWidth - featuredCardSpacing) / 2)
        )
    }
}

struct RepositoryNewView: View {
    @Environment(\.appLanguage) private var language
    @EnvironmentObject private var store: PackageRepositoryStore
    @State private var packages: [RepositoryPackageRecord] = []
    @State private var showSimulatedPackageDetail = false
    @State private var simulatedPackageDetailGate = OneShotPresentationGate()

    let onOpenSettings: () -> Void
    let onOpenLogs: () -> Void

    var body: some View {
        NavigationStack {
            List {
                if packages.isEmpty {
                    Section {
                        emptyState
                    }
                } else {
                    Section {
                        ForEach(packages) { record in
                            NavigationLink(value: record) {
                                RepositoryNewPackageRow(record: record)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(language.text("tab.new"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                AppUtilityToolbar(
                    language: language,
                    onOpenSettings: onOpenSettings,
                    onOpenLogs: onOpenLogs
                )
            }
            .navigationDestination(for: RepositoryPackageRecord.self) { record in
                RepositoryPackageDetailView(record: record)
            }
            .navigationDestination(isPresented: $showSimulatedPackageDetail) {
                if let record = packages.first {
                    RepositoryPackageDetailView(record: record)
                }
            }
            .refreshable {
                await store.refreshAllAndWait()
                rebuildPackages()
            }
            .onAppear {
                store.refreshAllIfNeeded()
                rebuildPackages()
                openSimulatedPackageDetailIfNeeded()
            }
            .onChange(of: store.packages) { _ in
                rebuildPackages()
                openSimulatedPackageDetailIfNeeded()
            }
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        if store.isRefreshing && !store.sources.isEmpty {
            HStack(spacing: 10) {
                ProgressView()
                Text(language.text("repository.refreshing"))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
        } else {
            VStack(spacing: 12) {
                Image(systemName: store.sources.isEmpty ? "shippingbox" : "clock")
                    .font(.system(size: AppTheme.emptyIconSize, weight: .light))
                    .foregroundStyle(AppTheme.accent)
                Text(language.text(
                    store.sources.isEmpty
                        ? "repository.no_sources_title"
                        : "repository.new_empty_title"
                ))
                .font(.headline)
                Text(language.text(
                    store.sources.isEmpty
                        ? "repository.no_sources_message"
                        : "repository.new_empty_message"
                ))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 48)
        }
    }

    private func rebuildPackages() {
        packages = PackageRepositoryFeedPolicy.newest(store.packages)
    }

    private func openSimulatedPackageDetailIfNeeded() {
#if targetEnvironment(simulator)
        guard ProcessInfo.processInfo.arguments.contains(
            "--simulate-package-detail"
        ), !packages.isEmpty, simulatedPackageDetailGate.claim() else {
            return
        }
        DispatchQueue.main.async {
            showSimulatedPackageDetail = true
        }
#endif
    }
}

struct RepositorySearchView: View {
    @Environment(\.appLanguage) private var language
    @EnvironmentObject private var store: PackageRepositoryStore
    @State private var searchText = ""

    let onOpenSettings: () -> Void
    let onOpenLogs: () -> Void

    private var query: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var results: [RepositoryPackageRecord] {
        guard !query.isEmpty else { return [] }
        return store.packages.filter { record in
            let package = record.package
            return package.name.localizedCaseInsensitiveContains(query)
                || package.author.localizedCaseInsensitiveContains(query)
                || package.summary.localizedCaseInsensitiveContains(query)
                || package.identifier.localizedCaseInsensitiveContains(query)
                || record.sourceName.localizedCaseInsensitiveContains(query)
                || (package.category?.localizedCaseInsensitiveContains(query) ?? false)
                || package.tags.contains {
                    $0.localizedCaseInsensitiveContains(query)
                }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AppSearchField(
                    text: $searchText,
                    prompt: language.text("repository.search_prompt"),
                    clearLabel: language.text("common.clear")
                )
                Divider()
                List {
                    if query.isEmpty {
                        searchPrompt
                            .listRowSeparator(.hidden)
                    } else if results.isEmpty {
                        searchEmpty
                            .listRowSeparator(.hidden)
                    } else {
                        Section(language.text(
                            "repository.search_results",
                            Int64(results.count)
                        )) {
                            ForEach(results) { record in
                                NavigationLink(value: record) {
                                    RepositoryPackageRow(record: record)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .scrollDismissesKeyboard(.interactively)
                .refreshable {
                    await store.refreshAllAndWait()
                }
            }
            .navigationTitle(language.text("repository.search"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                AppUtilityToolbar(
                    language: language,
                    onOpenSettings: onOpenSettings,
                    onOpenLogs: onOpenLogs
                )
            }
            .navigationDestination(for: RepositoryPackageRecord.self) { record in
                RepositoryPackageDetailView(record: record)
            }
            .onAppear {
                store.refreshAllIfNeeded()
            }
        }
    }

    private var searchPrompt: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: AppTheme.emptyIconSize, weight: .light))
                .foregroundStyle(AppTheme.accent)
            Text(language.text("repository.search_title"))
                .font(.headline)
            Text(language.text("repository.search_message"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 64)
    }

    private var searchEmpty: some View {
        VStack(spacing: 12) {
            Image(systemName: "shippingbox")
                .font(.system(size: AppTheme.emptyIconSize, weight: .light))
                .foregroundStyle(.secondary)
            Text(language.text("repository.search_empty"))
                .font(.headline)
            Text(language.text("repository.search_empty_message"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 64)
    }
}

private struct RepositoryFeaturedCard: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @StateObject private var imageLoader = RepositoryImageLoader()
    let record: RepositoryPackageRecord
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            artwork

            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.28),
                    .init(color: .black.opacity(0.16), location: 0.56),
                    .init(color: .black.opacity(0.78), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(record.package.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? 3 : 2)

                Text(record.package.author)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.white.opacity(0.84))
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .shadow(color: .black.opacity(0.42), radius: 1, y: 1)
        }
        .frame(width: width, height: height, alignment: .bottomLeading)
        .background(Color(uiColor: .secondarySystemFill))
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(
                    Color(uiColor: .separator).opacity(0.24),
                    lineWidth: 0.5
                )
                .accessibilityHidden(true)
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .task(id: record.package.iconURL) {
            guard let iconURL = record.package.iconURL else { return }
            await imageLoader.load(url: iconURL, maximumPixelSize: 640)
        }
    }

    private var artwork: some View {
        Rectangle()
            .fill(Color(uiColor: .secondarySystemFill))
            .overlay {
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if imageLoader.didFail {
                    placeholder
                } else if record.package.iconURL == nil {
                    placeholder
                } else {
                    ProgressView()
                        .tint(.white)
                }
            }
            .clipped()
            .accessibilityHidden(true)
    }

    private var placeholder: some View {
        Image(systemName: record.package.kind == .wallpaper
            ? "photo.fill"
            : "shippingbox.fill")
            .font(.system(size: 30, weight: .medium))
            .foregroundStyle(.white.opacity(0.82))
    }
}

private struct RepositoryCardButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.72 : 1)
            .animation(
                reduceMotion ? nil : .easeOut(duration: 0.12),
                value: configuration.isPressed
            )
    }
}

private struct RepositoryNewPackageRow: View {
    @Environment(\.appLanguage) private var language
    let record: RepositoryPackageRecord

    var body: some View {
        HStack(spacing: 12) {
            RepositoryPackageIcon(package: record.package, size: 38)
            VStack(alignment: .leading, spacing: 3) {
                Text(record.package.name)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                Text(language.text(
                    "repository.home_package_meta",
                    record.package.author,
                    record.sourceName
                ))
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            }
            Spacer(minLength: 8)
            if let publishedAt = record.package.publishedAt {
                Text(
                    publishedAt,
                    format: .dateTime.day().month(.abbreviated)
                )
                .font(.caption2.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
            }
        }
        .padding(.vertical, 3)
        .accessibilityElement(children: .combine)
    }
}

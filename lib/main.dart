import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

void main() {
  runApp(const PortfolioApp());
}

// ══════════════════════════════════════════════════
//  YOUR PERSONAL INFO
// ══════════════════════════════════════════════════
const String kName     = 'Aditya Kumar Pradhan';
const String kRole     = '📊 Data Analyst  • Flutter Developer';
const String kTagline  = 'Turning raw data into insights that drive decisions.';
const String kEmail    = 'pradhan.adi586@gmail.com';
const String kPhone    = '+91-7326886586';
const String kLocation = 'Bhanjanagar, Odisha';
const String kGitHub   = 'https://github.com/Adiyxxah';
const String kLinkedIn = 'https://linkedin.com/in/aditya-pradhan9178';

// ══════════════════════════════════════════════════
//  URL LAUNCHER HELPER
//  GitHub  → opens github.com/Adiyxxah
//  LinkedIn→ opens linkedin.com/in/aditya-pradhan9178
//  Email   → opens Gmail compose window
// ══════════════════════════════════════════════════
Future<void> openLink(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

Future<void> openEmail(String email) async {
  final uri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {
      'subject': 'Hello Aditya – Portfolio Inquiry',
    },
  );
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aditya Kumar Pradhan – Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF080811),
        colorScheme: const ColorScheme.dark(
          primary:   Color(0xFF6C63FF),
          secondary: Color(0xFF00D4FF),
          surface:   Color(0xFF12121A),
        ),
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});
  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with TickerProviderStateMixin {

  late AnimationController _heroCtrl;
  late AnimationController _particleCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _floatCtrl;

  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;
  late Animation<double> _titleScale;
  late Animation<double> _pulseAnim;
  late Animation<double> _floatAnim;

  int _selectedSection = 0;
  final ScrollController _scroll = ScrollController();
  final List<GlobalKey> _keys    = List.generate(5, (_) => GlobalKey());
  final List<String> _navItems   = ['Home','About','Experience','Skills','Projects'];

  @override
  void initState() {
    super.initState();
    _heroCtrl     = AnimationController(duration: const Duration(milliseconds: 1800), vsync: this);
    _particleCtrl = AnimationController(duration: const Duration(seconds: 10),        vsync: this)..repeat();
    _pulseCtrl    = AnimationController(duration: const Duration(seconds: 2),         vsync: this)..repeat(reverse: true);
    _floatCtrl    = AnimationController(duration: const Duration(seconds: 3),         vsync: this)..repeat(reverse: true);

    _heroFade   = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _heroCtrl, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)));
    _heroSlide  = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(CurvedAnimation(parent: _heroCtrl, curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic)));
    _titleScale = Tween<double>(begin: 0.75, end: 1.0)
        .animate(CurvedAnimation(parent: _heroCtrl, curve: const Interval(0.2, 0.9, curve: Curves.elasticOut)));
    _pulseAnim  = Tween<double>(begin: 0.92, end: 1.08)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _floatAnim  = Tween<double>(begin: -6.0, end: 6.0)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    Future.delayed(const Duration(milliseconds: 300), () { if (mounted) _heroCtrl.forward(); });
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _particleCtrl.dispose();
    _pulseCtrl.dispose();
    _floatCtrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollTo(int i) {
    setState(() => _selectedSection = i);
    final ctx = _keys[i].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _particleCtrl,
            builder: (_, __) => CustomPaint(
              painter: ParticlePainter(_particleCtrl.value),
              size: MediaQuery.of(context).size,
            ),
          ),
          Column(children: [
            _buildNavBar(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scroll,
                child: Column(children: [
                  _buildHero(),
                  _buildAbout(),
                  _buildExperience(),
                  _buildSkills(),
                  _buildProjects(),
                  _buildFooter(),
                ]),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  // ─── NAVBAR ─────────────────────────────────────
  Widget _buildNavBar() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF080811).withOpacity(0.97),
        border: Border(bottom: BorderSide(color: const Color(0xFF6C63FF).withOpacity(0.25))),
        boxShadow: [BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.06), blurRadius: 20)],
      ),
      child: Row(children: [
        const SizedBox(width: 28),
        AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, __) => Transform.scale(
            scale: _pulseAnim.value,
            child: ShaderMask(
              shaderCallback: (b) => const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)]).createShader(b),
              child: const Text('AKP', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3)),
            ),
          ),
        ),
        const Spacer(),
        ...List.generate(_navItems.length, (i) {
          final sel = _selectedSection == i;
          return GestureDetector(
            onTap: () => _scrollTo(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: sel ? const Color(0xFF6C63FF).withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: sel ? Border.all(color: const Color(0xFF6C63FF).withOpacity(0.6)) : null,
              ),
              child: Text(_navItems[i], style: TextStyle(
                color: sel ? const Color(0xFF6C63FF) : Colors.white54,
                fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                fontSize: 13,
              )),
            ),
          );
        }),
        const SizedBox(width: 28),
      ]),
    );
  }

  // ─── HERO ────────────────────────────────────────
  Widget _buildHero() {
    return Container(
      key: _keys[0],
      height: MediaQuery.of(context).size.height - 65,
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: _heroFade,
        child: SlideTransition(
          position: _heroSlide,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Floating photo with glow
              AnimatedBuilder(
                animation: Listenable.merge([_pulseAnim, _floatAnim]),
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, _floatAnim.value),
                  child: ScaleTransition(
                    scale: _titleScale,
                    child: Container(
                      width: 140, height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF00D4FF), Color(0xFFFF6CAB)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.55 * _pulseAnim.value), blurRadius: 40 * _pulseAnim.value, spreadRadius: 4),
                          BoxShadow(color: const Color(0xFF00D4FF).withOpacity(0.3), blurRadius: 20, spreadRadius: 1),
                        ],
                      ),
                      padding: const EdgeInsets.all(3),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/adi.jpeg',
                          fit: BoxFit.cover, width: 134, height: 134,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF12121A),
                            child: const Center(child: Text('AKP', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white))),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),
              const _TypewriterText(text: "Hi there 👋  I'm", style: TextStyle(fontSize: 18, color: Color(0xFF00D4FF), letterSpacing: 2)),
              const SizedBox(height: 10),

              ScaleTransition(
                scale: _titleScale,
                child: ShaderMask(
                  shaderCallback: (b) => const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF00D4FF), Color(0xFFFF6CAB)]).createShader(b),
                  child: const Text(kName, textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1)),
                ),
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                ),
                child: const Text(kRole, style: TextStyle(fontSize: 14, color: Colors.white70)),
              ),
              const SizedBox(height: 12),
              const Text(kTagline, textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.white38, fontStyle: FontStyle.italic)),
              const SizedBox(height: 32),

              // CTA buttons
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _GlowButton(label: 'View My Work', icon: Icons.arrow_downward_rounded, onTap: () => _scrollTo(2)),
                const SizedBox(width: 14),
                // Contact Me → opens Gmail compose
                _OutlineButton(
                  label: 'Contact Me',
                  icon: Icons.mail_outline_rounded,
                  onTap: () => openEmail(kEmail),
                ),
              ]),
              const SizedBox(height: 32),

              // ── Social chips — each opens the real URL ──
              Wrap(
                spacing: 12, runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  // GitHub → opens github.com/Adiyxxah
                  _SocialChip(
                    label: 'GitHub',
                    icon: Icons.code_rounded,
                    color: const Color(0xFF6C63FF),
                    onTap: () => openLink(kGitHub),
                  ),
                  // LinkedIn → opens linkedin.com/in/aditya-pradhan9178
                  _SocialChip(
                    label: 'LinkedIn',
                    icon: Icons.person_rounded,
                    color: const Color(0xFF0A66C2),
                    onTap: () => openLink(kLinkedIn),
                  ),
                  // Email → opens Gmail compose
                  _SocialChip(
                    label: kEmail,
                    icon: Icons.email_outlined,
                    color: const Color(0xFF00D4FF),
                    onTap: () => openEmail(kEmail),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── ABOUT ───────────────────────────────────────
  Widget _buildAbout() {
    return _SectionWrapper(
      sectionKey: _keys[1],
      title: 'About Me', subtitle: 'Who I am',
      child: LayoutBuilder(
        builder: (_, constraints) {
          final wide = constraints.maxWidth > 600;
          return Flex(
            direction: wide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: wide ? 3 : 1,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text(
                    "I'm a motivated MCA graduate from Lovely Professional University "
                        "with hands-on experience in Flutter, data analysis, Power BI dashboards, "
                        "SQL optimisation, and cloud storage on AWS. I love finding stories "
                        "hidden in raw data and turning them into actionable business insights.",
                    style: TextStyle(fontSize: 15, color: Colors.white70, height: 1.9),
                  ),
                  const SizedBox(height: 22),
                  Wrap(spacing: 10, runSpacing: 10, children: const [
                    _InfoChip(label: '📍 Bhanjanagar, Odisha'),
                    _InfoChip(label: '🎓 MCA – LPU (6.78 CGPA)'),
                    _InfoChip(label: '📞 +91-7326886586'),
                    _InfoChip(label: '💼 Open to Opportunities'),
                  ]),
                  const SizedBox(height: 22),
                  // About section social buttons — real links
                  Row(children: [
                    _SmallSocialBtn(
                      label: 'GitHub',
                      icon: Icons.code_rounded,
                      color: const Color(0xFF6C63FF),
                      onTap: () => openLink(kGitHub),   // ← opens github
                    ),
                    const SizedBox(width: 12),
                    _SmallSocialBtn(
                      label: 'LinkedIn',
                      icon: Icons.person_rounded,
                      color: const Color(0xFF0A66C2),
                      onTap: () => openLink(kLinkedIn), // ← opens linkedin
                    ),
                  ]),
                ]),
              ),
              SizedBox(width: wide ? 40 : 0, height: wide ? 0 : 28),
              Expanded(
                flex: wide ? 2 : 1,
                child: Column(children: const [
                  _StatCard(number: '2+', label: 'Years Experience', icon: Icons.work_outline_rounded),
                  SizedBox(height: 14),
                  _StatCard(number: '3',  label: 'Internships',      icon: Icons.school_outlined),
                  SizedBox(height: 14),
                  _StatCard(number: '5+', label: 'Certifications',   icon: Icons.verified_outlined),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── EXPERIENCE ──────────────────────────────────
  Widget _buildExperience() {
    return _SectionWrapper(
      sectionKey: _keys[2],
      title: 'Experience', subtitle: 'My Journey',
      child: Column(children: [
        _ExperienceCard(
          role: 'Associate', company: 'Tech Mahindra', period: 'Aug 2025 – Apr 2026',
          color: const Color(0xFF6C63FF), icon: Icons.business_rounded,
          bullets: const [
            'Collected and cleaned product datasets using Excel and SQL',
            'Built interactive Power BI dashboards for product performance insights',
            'Managed SKU systems and AWS S3 image/metadata storage for inventory',
            'Collaborated cross-functionally to validate large volumes of product data',
            'Maintained high accuracy standards across all reporting deliverables',
          ],
        ),
        const SizedBox(height: 18),
        _ExperienceCard(
          role: 'Junior Analyst Intern', company: 'Tech3i', period: 'Aug 2023 – Aug 2024',
          color: const Color(0xFF00D4FF), icon: Icons.analytics_rounded,
          bullets: const [
            'Supported ETL processes for structured data migration',
            'Wrote and optimised SQL queries for internal reporting',
            'Performed data validation to ensure data integrity',
            'Enhanced Excel-based reports with advanced formulas and formatting',
          ],
        ),
        const SizedBox(height: 18),
        _ExperienceCard(
          role: 'Flutter Developer Intern', company: 'Software Lab', period: 'May 2023 – Aug 2023',
          color: const Color(0xFFFF6CAB), icon: Icons.phone_android_rounded,
          bullets: const [
            'Built mobile app UIs using Flutter framework',
            'Integrated RESTful APIs for real-time data display',
            'Collaborated on UI/UX improvements and design discussions',
          ],
        ),
      ]),
    );
  }

  // ─── SKILLS ──────────────────────────────────────
  Widget _buildSkills() {
    return _SectionWrapper(
      sectionKey: _keys[3],
      title: 'Skills', subtitle: 'What I work with',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SkillGroup(category: '📊 Data Tools', skills: const [
          _SkillItem('Power BI', 0.85), _SkillItem('Excel', 0.90),
          _SkillItem('Tableau',  0.70), _SkillItem('Pandas', 0.75),
        ]),
        const SizedBox(height: 26),
        _SkillGroup(category: '💻 Languages', skills: const [
          _SkillItem('SQL', 0.85), _SkillItem('Python', 0.75), _SkillItem('Dart', 0.65),
        ]),
        const SizedBox(height: 26),
        _SkillGroup(category: '☁️ Cloud & Databases', skills: const [
          _SkillItem('MySQL', 0.80), _SkillItem('AWS S3', 0.60),
        ]),
        const SizedBox(height: 26),
        const Text('🔑 Key Concepts', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white70)),
        const SizedBox(height: 12),
        Wrap(spacing: 10, runSpacing: 10, children: const [
          _TagChip('Data Cleaning'),     _TagChip('Data Visualisation'),
          _TagChip('EDA'),               _TagChip('Basic ETL'),
          _TagChip('Dashboard Design'),  _TagChip('Data Validation'),
          _TagChip('Report Automation'), _TagChip('Inventory Management'),
        ]),
      ]),
    );
  }

  // ─── PROJECTS ────────────────────────────────────
  Widget _buildProjects() {
    return _SectionWrapper(
      sectionKey: _keys[4],
      title: 'Projects', subtitle: 'What I have built',
      child: Column(children: [
        _ProjectCard(
          title: 'Sales Dashboard – Power BI',
          description: 'Interactive Power BI dashboard visualising product sales KPIs, inventory levels, and category performance with drill-down filters.',
          tags: const ['Power BI', 'Excel', 'SQL'],
          color: const Color(0xFF6C63FF), icon: Icons.bar_chart_rounded,
          isComingSoon: false,
          onGitHub: () => openLink(kGitHub), // opens your GitHub
        ),
        const SizedBox(height: 16),
        _ProjectCard(
          title: 'EDA on E-Commerce Dataset',
          description: 'Exploratory data analysis on a large e-commerce dataset using Pandas and Matplotlib to uncover customer behaviour patterns.',
          tags: const ['Python', 'Pandas', 'Matplotlib'],
          color: const Color(0xFF00D4FF), icon: Icons.data_exploration_rounded,
          isComingSoon: false,
          onGitHub: () => openLink(kGitHub),
        ),
        const SizedBox(height: 16),
        _ProjectCard(
          title: 'Next Project Here',
          description: 'I will create something new.',
          tags: const ['Coming Soon'],
          color: const Color(0xFFFF6CAB), icon: Icons.add_circle_outline_rounded,
          isComingSoon: true,
          onGitHub: () => openLink(kGitHub),
        ),
      ]),
    );
  }

  // ─── FOOTER ──────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 40),
      child: Column(children: [
        Divider(color: Colors.white.withOpacity(0.08)),
        const SizedBox(height: 26),
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)]).createShader(b),
          child: const Text(kName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
        const SizedBox(height: 6),
        const Text('Data Analyst  •  Flutter developer', style: TextStyle(color: Colors.white38, fontSize: 13)),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _FooterLink(label: 'GitHub',   onTap: () => openLink(kGitHub)),
          const SizedBox(width: 24),
          _FooterLink(label: 'LinkedIn', onTap: () => openLink(kLinkedIn)),
          const SizedBox(width: 24),
          _FooterLink(label: 'Email',    onTap: () => openEmail(kEmail)),
        ]),
        const SizedBox(height: 18),
        Text('© 2025 Aditya Kumar Pradhan  •  Built with Flutter 💜',
            style: TextStyle(color: Colors.white.withOpacity(0.15), fontSize: 12)),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════
//  WIDGETS
// ══════════════════════════════════════════════════

class _SectionWrapper extends StatelessWidget {
  final GlobalKey sectionKey;
  final String title, subtitle;
  final Widget child;
  const _SectionWrapper({required this.sectionKey, required this.title, required this.subtitle, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    key: sectionKey,
    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 70),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(subtitle.toUpperCase(), style: const TextStyle(fontSize: 11, color: Color(0xFF6C63FF), letterSpacing: 4, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Text(title, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1)),
      const SizedBox(height: 8),
      Container(width: 56, height: 4, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)]), borderRadius: BorderRadius.circular(2))),
      const SizedBox(height: 42),
      child,
    ]),
  );
}

class _GlowButton extends StatefulWidget {
  final String label; final IconData icon; final VoidCallback onTap;
  const _GlowButton({required this.label, required this.icon, required this.onTap});
  @override State<_GlowButton> createState() => _GlowButtonState();
}
class _GlowButtonState extends State<_GlowButton> {
  bool _h = false;
  @override Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _h = true),
    onExit:  (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: _h ? [BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.65), blurRadius: 28, spreadRadius: 2)] : [],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(width: 8),
          Icon(widget.icon, size: 16, color: Colors.white),
        ]),
      ),
    ),
  );
}

class _OutlineButton extends StatefulWidget {
  final String label; final IconData icon; final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.icon, required this.onTap});
  @override State<_OutlineButton> createState() => _OutlineButtonState();
}
class _OutlineButtonState extends State<_OutlineButton> {
  bool _h = false;
  @override Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _h = true),
    onExit:  (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
        decoration: BoxDecoration(
          color: _h ? const Color(0xFF6C63FF).withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.6)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.label, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 14)),
          const SizedBox(width: 8),
          Icon(widget.icon, size: 16, color: Colors.white54),
        ]),
      ),
    ),
  );
}

class _SocialChip extends StatefulWidget {
  final String label; final IconData icon; final Color color; final VoidCallback onTap;
  const _SocialChip({required this.label, required this.icon, required this.color, required this.onTap});
  @override State<_SocialChip> createState() => _SocialChipState();
}
class _SocialChipState extends State<_SocialChip> {
  bool _h = false;
  @override Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _h = true),
    onExit:  (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: _h ? widget.color.withOpacity(0.2) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _h ? widget.color.withOpacity(0.8) : Colors.white.withOpacity(0.12)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(widget.icon, size: 15, color: _h ? widget.color : Colors.white54),
          const SizedBox(width: 6),
          Text(widget.label, style: TextStyle(fontSize: 12, color: _h ? widget.color : Colors.white54)),
          if (_h) ...[const SizedBox(width: 4), Icon(Icons.open_in_new, size: 11, color: widget.color)],
        ]),
      ),
    ),
  );
}

class _SmallSocialBtn extends StatefulWidget {
  final String label; final IconData icon; final Color color; final VoidCallback onTap;
  const _SmallSocialBtn({required this.label, required this.icon, required this.color, required this.onTap});
  @override State<_SmallSocialBtn> createState() => _SmallSocialBtnState();
}
class _SmallSocialBtnState extends State<_SmallSocialBtn> {
  bool _h = false;
  @override Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _h = true),
    onExit:  (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: _h ? widget.color.withOpacity(0.2) : widget.color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: widget.color.withOpacity(_h ? 0.8 : 0.3)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(widget.icon, size: 15, color: widget.color),
          const SizedBox(width: 6),
          Text(widget.label, style: TextStyle(color: widget.color, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          Icon(Icons.open_in_new, size: 12, color: widget.color.withOpacity(0.7)),
        ]),
      ),
    ),
  );
}

class _InfoChip extends StatelessWidget {
  final String label;
  const _InfoChip({required this.label});
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
    decoration: BoxDecoration(color: const Color(0xFF6C63FF).withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3))),
    child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
  );
}

class _StatCard extends StatelessWidget {
  final String number, label; final IconData icon;
  const _StatCard({required this.number, required this.label, required this.icon});
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: const Color(0xFF12121A), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2))),
    child: Row(children: [
      Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFF6C63FF).withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF6C63FF), size: 22)),
      const SizedBox(width: 16),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ShaderMask(shaderCallback: (b) => const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)]).createShader(b),
            child: Text(number, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white))),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ]),
    ]),
  );
}

class _ExperienceCard extends StatefulWidget {
  final String role, company, period; final Color color; final IconData icon; final List<String> bullets;
  const _ExperienceCard({required this.role, required this.company, required this.period, required this.color, required this.icon, required this.bullets});
  @override State<_ExperienceCard> createState() => _ExperienceCardState();
}
class _ExperienceCardState extends State<_ExperienceCard> {
  bool _exp = false;
  @override Widget build(BuildContext context) => GestureDetector(
    onTap: () => setState(() => _exp = !_exp),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300), curve: Curves.easeInOutCubic,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF12121A), borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _exp ? widget.color.withOpacity(0.55) : widget.color.withOpacity(0.15)),
        boxShadow: _exp ? [BoxShadow(color: widget.color.withOpacity(0.12), blurRadius: 22, offset: const Offset(0, 5))] : [],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: widget.color.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: widget.color.withOpacity(0.3))),
              child: Icon(widget.icon, color: widget.color, size: 20)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.role, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 2),
            Row(children: [
              Text(widget.company, style: TextStyle(fontSize: 13, color: widget.color, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Text(widget.period, style: const TextStyle(fontSize: 11, color: Colors.white38)),
            ]),
          ])),
          AnimatedRotation(turns: _exp ? 0.5 : 0, duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white38)),
        ]),
        AnimatedSize(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOutCubic,
          child: _exp ? Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.bullets.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(margin: const EdgeInsets.only(top: 6, right: 10), width: 5, height: 5, decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle)),
                    Expanded(child: Text(b, style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.5))),
                  ]),
                )).toList()),
          ) : const SizedBox.shrink(),
        ),
      ]),
    ),
  );
}

class _SkillGroup extends StatelessWidget {
  final String category; final List<_SkillItem> skills;
  const _SkillGroup({required this.category, required this.skills});
  @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(category, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white70)),
    const SizedBox(height: 14),
    ...skills.map((s) => _AnimatedSkillBar(skill: s)),
  ]);
}

class _SkillItem { final String name; final double level; const _SkillItem(this.name, this.level); }

class _AnimatedSkillBar extends StatefulWidget {
  final _SkillItem skill;
  const _AnimatedSkillBar({required this.skill});
  @override State<_AnimatedSkillBar> createState() => _AnimatedSkillBarState();
}
class _AnimatedSkillBarState extends State<_AnimatedSkillBar> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;
  @override void initState() {
    super.initState();
    _c = AnimationController(duration: const Duration(milliseconds: 1300), vsync: this);
    _a = Tween<double>(begin: 0, end: widget.skill.level).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 500), () { if (mounted) _c.forward(); });
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(widget.skill.name, style: const TextStyle(color: Colors.white60, fontSize: 13)),
        AnimatedBuilder(animation: _a, builder: (_, __) => Text('${(_a.value * 100).toInt()}%', style: const TextStyle(color: Color(0xFF6C63FF), fontSize: 12, fontWeight: FontWeight.w600))),
      ]),
      const SizedBox(height: 6),
      Container(height: 6, decoration: BoxDecoration(color: Colors.white.withOpacity(0.07), borderRadius: BorderRadius.circular(3)),
          child: AnimatedBuilder(animation: _a, builder: (_, __) => FractionallySizedBox(
              alignment: Alignment.centerLeft, widthFactor: _a.value,
              child: Container(decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)]), borderRadius: BorderRadius.circular(3)))))),
    ]),
  );
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip(this.label);
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
    decoration: BoxDecoration(color: const Color(0xFF6C63FF).withOpacity(0.08), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.25))),
    child: Text(label, style: const TextStyle(color: Color(0xFF6C63FF), fontSize: 12, fontWeight: FontWeight.w500)),
  );
}

class _ProjectCard extends StatefulWidget {
  final String title, description; final List<String> tags; final Color color; final IconData icon;
  final bool isComingSoon; final VoidCallback onGitHub;
  const _ProjectCard({required this.title, required this.description, required this.tags, required this.color, required this.icon, required this.isComingSoon, required this.onGitHub});
  @override State<_ProjectCard> createState() => _ProjectCardState();
}
class _ProjectCardState extends State<_ProjectCard> {
  bool _h = false;
  @override Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _h = true),
    onExit:  (_) => setState(() => _h = false),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      transform: _h ? (Matrix4.identity()..translate(0.0, -5.0)) : Matrix4.identity(),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF12121A), borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _h ? widget.color.withOpacity(0.5) : widget.color.withOpacity(0.15)),
        boxShadow: _h ? [BoxShadow(color: widget.color.withOpacity(0.18), blurRadius: 28, offset: const Offset(0, 6))] : [],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(widget.icon, color: widget.color, size: 26),
          const SizedBox(width: 12),
          Expanded(child: Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))),
          widget.isComingSoon
              ? Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: widget.color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Text('Coming Soon', style: TextStyle(color: widget.color, fontSize: 11)))
              : GestureDetector(
            onTap: widget.onGitHub,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: widget.color.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: widget.color.withOpacity(0.4))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.code_rounded, color: widget.color, size: 14),
                const SizedBox(width: 4),
                Text('GitHub', style: TextStyle(color: widget.color, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(width: 3),
                Icon(Icons.open_in_new, size: 11, color: widget.color.withOpacity(0.7)),
              ]),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        Text(widget.description, style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.6)),
        const SizedBox(height: 14),
        Wrap(spacing: 8, runSpacing: 8, children: widget.tags.map((t) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: widget.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Text(t, style: TextStyle(color: widget.color, fontSize: 11, fontWeight: FontWeight.w500)),
        )).toList()),
      ]),
    ),
  );
}

class _FooterLink extends StatefulWidget {
  final String label; final VoidCallback onTap;
  const _FooterLink({required this.label, required this.onTap});
  @override State<_FooterLink> createState() => _FooterLinkState();
}
class _FooterLinkState extends State<_FooterLink> {
  bool _h = false;
  @override Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) => setState(() => _h = true),
    onExit:  (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 150),
        style: TextStyle(color: _h ? const Color(0xFF6C63FF) : Colors.white38, fontSize: 13,
            decoration: _h ? TextDecoration.underline : TextDecoration.none,
            decorationColor: const Color(0xFF6C63FF)),
        child: Text(widget.label),
      ),
    ),
  );
}

class _TypewriterText extends StatefulWidget {
  final String text; final TextStyle style;
  const _TypewriterText({required this.text, required this.style});
  @override State<_TypewriterText> createState() => _TypewriterTextState();
}
class _TypewriterTextState extends State<_TypewriterText> {
  String _d = ''; int _i = 0;
  @override void initState() { super.initState(); Future.delayed(const Duration(milliseconds: 900), _next); }
  void _next() {
    if (!mounted) return;
    if (_i < widget.text.length) { setState(() { _d += widget.text[_i]; _i++; }); Future.delayed(const Duration(milliseconds: 55), _next); }
  }
  @override Widget build(BuildContext context) => Text(_d, style: widget.style);
}

class ParticlePainter extends CustomPainter {
  final double progress;
  static final _pts = List.generate(60, (i) => [(i * 137.5) % 100, (i * 73.3) % 100, (i % 3) * 1.0 + 0.5, (i % 5) * 0.2 + 0.1, (i * 0.63) % 1.0]);
  const ParticlePainter(this.progress);
  @override void paint(Canvas canvas, Size size) {
    final p = Paint()..style = PaintingStyle.fill;
    for (final pt in _pts) {
      final x = pt[0] / 100 * size.width;
      final y = (pt[1] / 100 * size.height - progress * size.height * pt[3] * 0.3 + size.height) % size.height;
      final op = (math.sin((progress + pt[4]) * math.pi * 2) * 0.5 + 0.5) * 0.2 + 0.04;
      p.color = const Color(0xFF6C63FF).withOpacity(op);
      canvas.drawCircle(Offset(x, y), pt[2], p);
    }
  }
  @override bool shouldRepaint(ParticlePainter o) => o.progress != progress;
}

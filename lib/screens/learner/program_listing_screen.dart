import 'package:flutter/material.dart';
import 'program_details_screen.dart';

class ResponsiveLayout {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static int getGridCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }
}

// Simple Program model for the listing
class ProgramBasic {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String thumbnailUrl;
  final String category;
  final String difficulty;
  final String duration;
  final double? progress;
  final bool isEnrolled;
  final bool isCompleted;

  ProgramBasic({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.thumbnailUrl,
    required this.category,
    required this.difficulty,
    required this.duration,
    this.progress,
    this.isEnrolled = false,
    this.isCompleted = false,
  });
}

class ProgramListingScreen extends StatefulWidget {
  const ProgramListingScreen({super.key});

  @override
  State<ProgramListingScreen> createState() => _ProgramListingScreenState();
}

class _ProgramListingScreenState extends State<ProgramListingScreen> {
  int _selectedSegment = 0; // 0: Enrolled, 1: Available, 2: Completed
  String _searchQuery = '';
  bool _isGridView = false;
  Set<String> _selectedFilters = {};

  // Sample data - Replace with actual API call later
  final List<ProgramBasic> _allPrograms = [
    ProgramBasic(
      id: '1',
      title: 'Introduction to Flutter',
      description:
          'Learn the basics of Flutter development and build beautiful cross-platform apps.',
      instructor: 'Dr. Sarah Chen',
      thumbnailUrl: 'https://picsum.photos/seed/flutter/400/300',
      category: 'Mobile Development',
      difficulty: 'Beginner',
      duration: '8 weeks',
      progress: 0.65,
      isEnrolled: true,
    ),
    ProgramBasic(
      id: '2',
      title: 'Advanced Data Structures',
      description:
          'Deep dive into complex data structures and algorithms for efficient problem solving.',
      instructor: 'Prof. Michael Torres',
      thumbnailUrl: 'https://picsum.photos/seed/data/400/300',
      category: 'Computer Science',
      difficulty: 'Advanced',
      duration: '12 weeks',
      progress: 0.30,
      isEnrolled: true,
    ),
    ProgramBasic(
      id: '3',
      title: 'Digital Marketing Fundamentals',
      description:
          'Master the essentials of digital marketing including SEO, social media, and analytics.',
      instructor: 'Emily Rodriguez',
      thumbnailUrl: 'https://picsum.photos/seed/marketing/400/300',
      category: 'Marketing',
      difficulty: 'Beginner',
      duration: '6 weeks',
      isEnrolled: false,
    ),
    ProgramBasic(
      id: '4',
      title: 'Machine Learning Basics',
      description:
          'Introduction to machine learning concepts, algorithms, and practical applications.',
      instructor: 'Dr. James Wilson',
      thumbnailUrl: 'https://picsum.photos/seed/ml/400/300',
      category: 'Data Science',
      difficulty: 'Intermediate',
      duration: '10 weeks',
      progress: 1.0,
      isEnrolled: true,
      isCompleted: true,
    ),
    ProgramBasic(
      id: '5',
      title: 'Web Development Bootcamp',
      description:
          'Complete guide to modern web development with HTML, CSS, JavaScript, and frameworks.',
      instructor: 'Alex Kim',
      thumbnailUrl: 'https://picsum.photos/seed/web/400/300',
      category: 'Web Development',
      difficulty: 'Beginner',
      duration: '16 weeks',
      isEnrolled: false,
    ),
    ProgramBasic(
      id: '6',
      title: 'Python Programming',
      description:
          'Comprehensive Python course covering basics to advanced topics.',
      instructor: 'Lisa Anderson',
      thumbnailUrl: 'https://picsum.photos/seed/python/400/300',
      category: 'Programming',
      difficulty: 'Beginner',
      duration: '10 weeks',
      isEnrolled: false,
    ),
    // NEW PROGRAMS BELOW
    ProgramBasic(
      id: '7',
      title: 'Cloud Computing with AWS',
      description:
          'Learn to build, deploy, and manage applications on Amazon Web Services cloud platform.',
      instructor: 'David Martinez',
      thumbnailUrl: 'https://picsum.photos/seed/aws/400/300',
      category: 'Cloud Computing',
      difficulty: 'Intermediate',
      duration: '14 weeks',
      progress: 0.45,
      isEnrolled: true,
    ),
    ProgramBasic(
      id: '8',
      title: 'UI/UX Design Masterclass',
      description:
          'Master user interface and user experience design principles with hands-on projects.',
      instructor: 'Sophie Taylor',
      thumbnailUrl: 'https://picsum.photos/seed/uiux/400/300',
      category: 'Design',
      difficulty: 'Beginner',
      duration: '8 weeks',
      isEnrolled: false,
    ),
    ProgramBasic(
      id: '9',
      title: 'Cybersecurity Essentials',
      description:
          'Understand network security, ethical hacking, and protect systems from cyber threats.',
      instructor: 'Prof. Robert Clarke',
      thumbnailUrl: 'https://picsum.photos/seed/security/400/300',
      category: 'Cybersecurity',
      difficulty: 'Advanced',
      duration: '12 weeks',
      isEnrolled: false,
    ),
    ProgramBasic(
      id: '10',
      title: 'React Native Mobile Apps',
      description:
          'Build cross-platform mobile applications using React Native and JavaScript.',
      instructor: 'Nina Patel',
      thumbnailUrl: 'https://picsum.photos/seed/reactnative/400/300',
      category: 'Mobile Development',
      difficulty: 'Intermediate',
      duration: '10 weeks',
      progress: 0.80,
      isEnrolled: true,
    ),
    ProgramBasic(
      id: '11',
      title: 'Blockchain Development',
      description:
          'Learn blockchain technology, smart contracts, and decentralized application development.',
      instructor: 'Dr. Ahmed Hassan',
      thumbnailUrl: 'https://picsum.photos/seed/blockchain/400/300',
      category: 'Blockchain',
      difficulty: 'Advanced',
      duration: '16 weeks',
      isEnrolled: false,
    ),
  ];
  List<ProgramBasic> get _filteredPrograms {
    List<ProgramBasic> filtered = _allPrograms;

    // Filter by segment
    if (_selectedSegment == 0) {
      filtered = filtered.where((p) => p.isEnrolled && !p.isCompleted).toList();
    } else if (_selectedSegment == 1) {
      filtered = filtered.where((p) => !p.isEnrolled).toList();
    } else if (_selectedSegment == 2) {
      filtered = filtered.where((p) => p.isCompleted).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (p) =>
                p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                p.instructor.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    // Filter by selected filters
    if (_selectedFilters.isNotEmpty) {
      filtered = filtered
          .where(
            (p) =>
                _selectedFilters.contains(p.category) ||
                _selectedFilters.contains(p.difficulty),
          )
          .toList();
    }

    return filtered;
  }

  void _navigateToProgramDetails(ProgramBasic program) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProgramDetailsScreen(programId: program.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programs'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement pull-to-refresh with actual API
          await Future.delayed(const Duration(seconds: 1));
          setState(() {});
        },
        child: Column(
          children: [
            // Segmented Control
            Container(
              padding: const EdgeInsets.all(16),
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(
                    value: 0,
                    label: Text('Enrolled'),
                    icon: Icon(Icons.school),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text('Available'),
                    icon: Icon(Icons.explore),
                  ),
                  ButtonSegment(
                    value: 2,
                    label: Text('Completed'),
                    icon: Icon(Icons.check_circle),
                  ),
                ],
                selected: {_selectedSegment},
                onSelectionChanged: (Set<int> selected) {
                  setState(() {
                    _selectedSegment = selected.first;
                  });
                },
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search programs...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // Filter Chips
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  _buildFilterChip('Mobile Development'),
                  _buildFilterChip('Web Development'),
                  _buildFilterChip('Data Science'),
                  _buildFilterChip('Computer Science'),
                  _buildFilterChip('Cloud Computing'),
                  _buildFilterChip('Design'),
                  _buildFilterChip('Cybersecurity'),
                  _buildFilterChip('Blockchain'),
                  _buildFilterChip('Beginner'),
                  _buildFilterChip('Intermediate'),
                  _buildFilterChip('Advanced'),
                ],
              ),
            ),

            // Program List/Grid
            Expanded(
              child: _filteredPrograms.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No programs found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : _isGridView
                  ? _buildGridView()
                  : _buildListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveLayout.getGridCrossAxisCount(context),
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredPrograms.length,
      itemBuilder: (context, index) {
        final program = _filteredPrograms[index];
        return _buildProgramGridCard(program);
      },
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilters.contains(label);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            if (selected) {
              _selectedFilters.add(label);
            } else {
              _selectedFilters.remove(label);
            }
          });
        },
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredPrograms.length,
      itemBuilder: (context, index) {
        final program = _filteredPrograms[index];
        return _buildProgramCard(program);
      },
    );
  }

  Widget _buildProgramCard(ProgramBasic program) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToProgramDetails(program),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Image.network(
              program.thumbnailUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 64),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    program.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    program.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Instructor and Duration
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          program.instructor,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        program.duration,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),

                  // Progress bar (if enrolled)
                  if (program.isEnrolled && program.progress != null) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: program.progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(program.progress! * 100).toInt()}% Complete',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramGridCard(ProgramBasic program) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToProgramDetails(program),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Image.network(
              program.thumbnailUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 48),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    program.instructor,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (program.isEnrolled && program.progress != null) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: program.progress,
                        minHeight: 6,
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

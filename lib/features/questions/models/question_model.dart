class QuestionModel {
  final String id;
  final String text;
  final bool correctAnswer;
  final num scoreValue;

  QuestionModel({
    required this.id,
    required this.text,
    required this.correctAnswer,
    required this.scoreValue,
  });
}

final List<QuestionModel> questionsList = [
  QuestionModel(
    id: '1',
    text: 'هل الطفل قادر الآن على التحدث باستخدام عبارات قصيرة أو جمل؟',
    correctAnswer: true,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '2',
    text: 'هل أجريت محادثة معه/معها تتضمن تبادل الأدوار أو البناء على ما قلته؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '3',
    text:
        'هل يستخدم/تستخدم أحيانًا عبارات غريبة أو يقول الشيء نفسه مرارًا وتكرارًا بنفس الطريقة تقريبًا (سواء كانت عبارات يسمعها من الآخرين أو التي يختلقها بنفسه/بنفسها)؟',
    correctAnswer: true,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '4',
    text:
        'هل يسأل/تسأل أحيانًا أسئلة أو يصرح ببيانات اجتماعية غير ملائمة؟ على سبيل المثال، هل يسأل/تسأل بانتظام أسئلة شخصية أو يعلق/تعلق على أمور شخصية في أوقات محرجة؟',
    correctAnswer: true,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '5',
    text:
        'هل يخلط/تخلط أحيانًا الضمائر (مثل استخدام "أنت" أو "هو/هي" بدلاً من "أنا")؟',
    correctAnswer: false,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '6',
    text:
        'هل يستخدم/تستخدم أحيانًا كلمات يبدو أنه/أنها اخترعها بنفسه/بنفسها، أو يضع الأشياء بطرق غريبة أو غير مباشرة، أو يستخدم/تستخدم طرقًا مجازية في التعبير؟ (مثل قول "مطر حار" للبخار)؟',
    correctAnswer: true,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '7',
    text:
        'هل يقول/تقول الشيء نفسه مرارًا وتكرارًا بنفس الطريقة أو يصر على أنك تقول الشيء نفسه مرارًا وتكرارًا؟',
    correctAnswer: true,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '8',
    text:
        'هل لديه/لديها أشياء يبدو أنه/أنها يجب أن يفعلها بطريقة معينة جدًا أو طقوس يصر على أن يمر بها؟',
    correctAnswer: true,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '9',
    text:
        'هل تعبيراته/تعبيراتها الوجهية عادةً ما تبدو ملائمة للموقف المعين، حسبما تستطيع أن تخبر؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '10',
    text:
        'هل يستخدم/تستخدم يدك كأداة أو كما لو كانت جزءًا من جسده/جسدها (مثل الإشارة بإصبعك، أو وضع يدك على مقبض الباب لجعلك تفتح الباب)؟',
    correctAnswer: true,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '11',
    text:
        'هل لديه/لديها اهتمامات تشغل ذهنه/ذهنها وتبدو غريبة للناس الآخرين (مثل إشارات المرور، أنابيب التصريف، الجداول الزمنية)؟',
    correctAnswer: true,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '12',
    text:
        'هل يبدو أكثر اهتمامًا بأجزاء من لعبة أو شيء (مثل دوران عجلات سيارة) بدلاً من استخدام الأشياء كما هو مقصود؟',
    correctAnswer: false,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '13',
    text:
        'هل لديه/لديها اهتمامات خاصة تكون غير عادية في شدتها ولكنها مناسبة لسنّه/سنّها ومجموعة أقرانه/أقرانها (مثل القطارات أو الديناصورات)؟',
    correctAnswer: false,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '14',
    text:
        'هل يبدو مهتمًا بشكل غير عادي بمظهر أو شعور أو صوت أو طعم أو رائحة الأشياء أو الأشخاص؟',
    correctAnswer: true,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '15',
    text:
        'هل لديه/لديها أي حركات أو طرق غريبة في تحريك يديه/يديها أو أصابعه/أصابعها، مثل الخفقان أو تحريك أصابعه/أصابعها أمام عينيه/عينيها؟',
    correctAnswer: true,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '16',
    text:
        'هل لديه/لديها أي حركات معقدة لجسده/جسدها بالكامل، مثل الدوار أو القفز المتكرر لأعلى وأسفل؟',
    correctAnswer: true,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '17',
    text:
        'هل يتعمد/تتعمد إيذاء نفسه/نفسها، مثل عض ذراعه/ذراعها أو ضرب رأسه/رأسها؟',
    correctAnswer: false,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '18',
    text:
        'هل لديه/لديها أي أشياء (بخلاف لعبة ناعمة أو بطانية مريحة) يجب أن يحملها معه/معها؟',
    correctAnswer: false,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '19',
    text: 'هل لديه/لديها أصدقاء معينون أو صديق مفضل؟',
    correctAnswer: true,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '20',
    text: 'هل يتحدث/تتحدث معك فقط ليكون ودودًا (بدلاً من الحصول على شيء)؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '21',
    text:
        'هل ينسخ/تنسخ عفويًا ما تفعله أو ما يفعله الآخرون (مثل التنظيف بالمكنسة، أو البستنة، أو إصلاح الأشياء)؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '22',
    text:
        'هل يشير/تشير عفويًا إلى الأشياء من حوله/حولها فقط ليظهر لك الأشياء (ليس لأنه/لأنها يريدها)؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '23',
    text:
        'هل يستخدم/تستخدم إيماءات، بخلاف الإشارة أو سحب يدك، ليخبرك بما يريد؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '24',
    text: 'هل يومئ/تومئ برأسه/برأسها للإشارة إلى "نعم"؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '25',
    text: 'هل يهز/تهز رأسه/رأسها للإشارة إلى "لا"؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '26',
    text:
        'هل عادةً ما ينظر/تنظر إليك مباشرة في الوجه عند القيام بأشياء معك أو التحدث معك؟',
    correctAnswer: true,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '27',
    text: 'هل يبتسم/تبتسم إذا ابتسم أحدهم له/لها؟',
    correctAnswer: true,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '28',
    text: 'هل يظهر/تظهر لك أشياء تهمه/تهمها لجذب انتباهك؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '29',
    text: 'هل يقدم/تقدم أشياء لمشاركتها معك بخلاف الطعام؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '30',
    text: 'هل يبدو أنه/أنها يريدك أن تشارك في استمتاعه/استمتاعها بشيء؟',
    correctAnswer: true,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '31',
    text: 'هل يحاول/تحاول أن يواسيك إذا كنت حزينًا أو متألمًا؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '32',
    text:
        'إذا أراد/أرادت شيئًا أو مساعدة، هل ينظر إليك ويستخدم إيماءات مع أصوات أو كلمات لجذب انتباهك؟',
    correctAnswer: true,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '33',
    text: 'هل يظهر/تظهر مجموعة طبيعية من تعبيرات الوجه؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '34',
    text: 'هل ينضم/تنضم عفويًا ويحاول/تحاول نسخ الأفعال في الألعاب الاجتماعية؟',
    correctAnswer: true,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '35',
    text: 'هل يلعب/تلعب أي ألعاب تخيلية أو خيالية؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '36',
    text:
        'هل يبدو مهتمًا بالأطفال الآخرين في نفس العمر تقريبًا الذين لا يعرفهم؟',
    correctAnswer: true,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '37',
    text: 'هل يستجيب/تستجيب إيجابيًا عندما يقترب منه/منها طفل آخر؟',
    correctAnswer: true,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '38',
    text:
        'إذا دخلت غرفة وبدأت بالتحدث معه/معها دون مناداته/مناداتها باسم، هل عادةً ما ينظر/تنظر لأعلى ويعيرك انتباهه/انتباهها؟',
    correctAnswer: true,
    scoreValue: 0,
  ),
  QuestionModel(
    id: '39',
    text:
        'هل يلعب/تلعب ألعاب تخيلية مع طفل آخر بطريقة يمكنك أن تعرف أن كل طفل يفهم ما يقوم به الآخر؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
  QuestionModel(
    id: '40',
    text:
        'هل يلعب/تلعب بشكل تعاوني في ألعاب تحتاج إلى نوع من الانضمام مع مجموعة من الأطفال الآخرين، مثل الغميضة أو ألعاب الكرة؟',
    correctAnswer: false,
    scoreValue: 1,
  ),
];

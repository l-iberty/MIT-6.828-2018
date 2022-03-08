# LAB 5

## 修复 LAB 2 的 BUG

- `page_lookup`:

```c
struct PageInfo *page_lookup(pde_t *pgdir, void *va, pte_t **pte_store) {
  // Fill this function in
  pte_t *ppte;
  physaddr_t pa;

  ppte = pgdir_walk(pgdir, va, false);
  if (ppte == NULL) {
    return NULL;
  }
  // 需要添加这样一个判断
  if (!(*ppte & PTE_P)) {
    return NULL;
  }
  if (pte_store) {
    *pte_store = ppte;
  }
  pa = PTE_ADDR(*ppte);
  return pa2page(pa);
}
```

- `boot_map_region`以前的写法易读性较差且容易出错, 重写:

```c
static void boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm) {
  // Fill this function in
  assert(va % PGSIZE == 0);
  assert(pa % PGSIZE == 0);
  assert(size % PGSIZE == 0);

  int i;
  pte_t *ppte;

  for (i = 0; i < size / PGSIZE; i++) {
    ppte = pgdir_walk(pgdir, (const void *)va, true);
    assert(ppte);
    *ppte = pa | perm | PTE_P;
    va += PGSIZE;
    pa += PGSIZE;
  }
}
```

- `pgdir_walk`:

```c
pte_t *pgdir_walk(pde_t *pgdir, const void *va, int create) {
  // Fill this function in
  struct PageInfo *pp;
  pte_t *pgtable;

  pgtable = (pte_t *)PTE_ADDR(pgdir[PDX(va)]);

  // if (pgtable == NULL) {    /* 这样的判断是不对的, 虽然目前未造成异常 */
  if (!(pgdir[PDX(va)] & PTE_P)) {
    if (!create) {
      return NULL;
    }
    pp = page_alloc(ALLOC_ZERO);
    if (pp == NULL) {
      return NULL;
    }
    pp->pp_ref++;
    pgtable = (pte_t *)page2pa(pp);
    pgdir[PDX(va)] = (uintptr_t)pgtable | PTE_P | PTE_U | PTE_W;
  }
  pgtable = (pte_t *)KADDR((physaddr_t)pgtable);
  return &pgtable[PTX(va)];
}
```

## 修复 LAB 4 的 BUG

LAB 4 为了实现`sfork`而对`thisenv`做的那些修改在 LAB 5 会导致 shell 命令的管道无法正常运行, 尚不知其原因, 暂时将`thisenv`恢复成原本的样子.